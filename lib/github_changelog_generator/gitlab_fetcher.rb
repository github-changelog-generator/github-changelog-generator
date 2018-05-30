# frozen_string_literal: true

require 'date'
require "tmpdir"
require "retriable"
require "gitlab"


module GitHubChangelogGenerator
  # A Fetcher responsible for all requests to GitHub and all basic manipulation with related data
  # (such as filtering, validating, e.t.c)
  #
  # Example:
  # fetcher = GitHubChangelogGenerator::OctoFetcher.new(options)
  class GitlabFetcher
    PER_PAGE_NUMBER   = 100
    MAX_THREAD_NUMBER = 25
    MAX_FORBIDDEN_RETRIES = 100
    CHANGELOG_GITHUB_TOKEN = "CHANGELOG_GITHUB_TOKEN"
    GH_RATE_LIMIT_EXCEEDED_MSG = "Warning: Can't finish operation: GitHub API rate limit exceeded, changelog may be " \
    "missing some issues. You can limit the number of issues fetched using the `--max-issues NUM` argument."
    NO_TOKEN_PROVIDED = "Warning: No token provided (-t option) and variable $CHANGELOG_GITHUB_TOKEN was not found. " \
    "This script can make only 50 requests to GitHub API per hour without token!"

    # @param options [Hash] Options passed in
    # @option options [String] :user Gitlab username
    # @option options [String] :project Gitlab project
    # @option options [String] :since Only issues updated at or after this time are returned. This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ. eg. Time.parse("2016-01-01 10:00:00").iso8601
    # @option options [Boolean] :http_cache Use ActiveSupport::Cache::FileStore to cache http requests
    # @option options [Boolean] :cache_file If using http_cache, this is the cache file path
    # @option options [Boolean] :cache_log If using http_cache, this is the cache log file path
    def initialize(options = {})
      @options      = options || {}
      @user         = @options[:user]
      @project      = @options[:project]
      @since        = @options[:since]
      @http_cache   = @options[:http_cache]
      @cache_file   = nil
      @cache_log    = nil
      @commits      = []
      @compares     = {}

      Gitlab.sudo = nil
      @client = Gitlab::Client.new(gitlab_options)
      @project_id = @client.project_search(@project).first.id
    end

    def gitlab_options
      result = {}
      access_token = fetch_github_token
      result[:private_token] = access_token if access_token
      endpoint = @options[:github_endpoint]
      result[:endpoint] = endpoint if endpoint
      result
    end

    DEFAULT_REQUEST_OPTIONS = { per_page: PER_PAGE_NUMBER }

    # Fetch all tags from repo
    #
    # @return [Array <Hash>] array of tags
    def get_all_tags
      print "Fetching tags...\r" if @options[:verbose]

      check_response { fetch_tags }
    end

    # Fill input array with tags
    #
    # @return [Array <Hash>] array of tags in repo
    def fetch_tags
      tags        = []
      new_tags = @client.tags(@project_id, DEFAULT_REQUEST_OPTIONS)

      new_tags.auto_paginate do |new_tag|
        tags.push(new_tag)
      end
      print_empty_line

      if tags.count == 0
        Helper.log.warn "Warning: Can't find any tags in repo. \
Make sure, that you push tags to remote repo via 'git push --tags'"
      else
        Helper.log.info "Found #{tags.count} tags"
      end
      # tags are a Sawyer::Resource. Convert to hash
      tags.map { |resource| stringify_keys_deep(resource.to_hash) }
    end

    def closed_pr_options
      @closed_pr_options ||= {
        filter: "all", labels: nil, state: "merged"
      }.tap { |options| options[:since] = @since if @since }
    end

    # This method fetch all closed issues and separate them to pull requests and pure issues
    # (pull request is kind of issue in term of GitHub)
    #
    # @return [Tuple] with (issues [Array <Hash>], pull-requests [Array <Hash>])
    def fetch_closed_issues_and_pr
      print "Fetching closed issues...\r" if @options[:verbose]
      print_empty_line
      issues = @client.issues(@project_id, DEFAULT_REQUEST_OPTIONS)
      p issues.first

      print_empty_line
      Helper.log.info "Received issues: #{issues.count}"

      # separate arrays of issues and pull requests:
      return issues.map { |issue| stringify_keys_deep(issue.to_hash) }, fetch_closed_pull_requests
    end

    # Fetch all pull requests. We need them to detect :merged_at parameter
    #
    # @return [Array <Hash>] all pull requests
    def fetch_closed_pull_requests
      pull_requests = []
      options = { state: "merged",  scope: :all}

      @client.merge_requests(@project_id, options).auto_paginate do |new_pr|
        new_pr = stringify_keys_deep(new_pr.to_hash)
        # align with Github naming
        new_pr["number"] = new_pr["iid"]
        new_pr["merged_at"] = new_pr["updated_at"]
        pull_requests.push(new_pr)
      end

      print_empty_line

      Helper.log.info "Pull Request count: #{pull_requests.count}"
      pull_requests.map { |pull_request| stringify_keys_deep(pull_request.to_hash) }
    end

    # Fetch event for all issues and add them to 'events'
    #
    # @param [Array] issues
    # @return [Void]
    def fetch_events_async(issues)
      i       = 0
      threads = []

      issues.each_slice(MAX_THREAD_NUMBER) do |issues_slice|
        issues_slice.each do |issue|
          threads << Thread.new do
            issue["events"] = []
            @client.project_events(@project_id).auto_paginate do |new_event|
              issue["events"].push(new_event)
            end
            issue["events"] = issue["events"].map { |event| stringify_keys_deep(event.to_hash) }
            print_in_same_line("Fetching events for issues and PR: #{i + 1}/#{issues.count}")
            i += 1
          end
        end
        threads.each(&:join)
        threads = []
      end

      # to clear line from prev print
      print_empty_line

      Helper.log.info "Fetching events for issues and PR: #{i}"
    end

    # Fetch comments for PRs and add them to "comments"
    #
    # @param [Array] prs The array of PRs.
    # @return [Void] No return; PRs are updated in-place.
    def fetch_comments_async(prs)
      threads = []

      prs.each_slice(MAX_THREAD_NUMBER) do |prs_slice|
        prs_slice.each do |pr|
          threads << Thread.new do
            pr["comments"] = []
            @client.merge_request_notes(@project_id, pr["number"]) do |new_comment|
              pr["comments"].push(new_comment)
            end
            pr["comments"] = pr["comments"].map { |comment| stringify_keys_deep(comment.to_hash) }
          end
        end
        threads.each(&:join)
        threads = []
      end
      nil
    end

    # Fetch tag time from repo
    #
    # @param [Hash] tag GitHub data item about a Tag
    #
    # @return [Time] time of specified tag
    def fetch_date_of_tag(tag)
      DateTime.parse(tag["commit"]["committed_date"])
    end

    # Fetch and cache comparison between two github refs
    #
    # @param [String] older The older sha/tag/branch.
    # @param [String] newer The newer sha/tag/branch.
    # @return [Hash] Github api response for comparison.
    def fetch_compare(older, newer)
      unless @compares["#{older}...#{newer}"]
        compare_data = check_response { @client.compare(@project_id, older, newer || "HEAD") }
        compare_data = stringify_keys_deep(compare_data.to_hash)
        compare_data["commits"].each do |commit|
          commit["sha"] = commit["id"]
        end
        # TODO: do not know what the equivalent for gitlab is
        if compare_data["compare_same_ref"] == true then
          raise StandardError, "Sha #{older} and sha #{newer} are not related; please file a github-changelog-generator issues and describe how to replicate this issue."
        end
        @compares["#{older}...#{newer}"] = stringify_keys_deep(compare_data.to_hash)
      end
      @compares["#{older}...#{newer}"]
    end

    # Fetch commit for specified event
    #
    # @param [String] commit_id the SHA of a commit to fetch
    # @return [Hash]
    def fetch_commit(commit_id)
      found = commits.find do |commit|
        commit['sha'] == commit_id
      end
      if found
        stringify_keys_deep(found.to_hash)
      else
        # cache miss; don't add to @commits because unsure of order.
        check_response do
          commit = @client.commit(@project_id, commit_id)
          commit = stringify_keys_deep(commit.to_hash)
          commit['sha'] = commit['id']
          commit
        end
      end
    end

    # Fetch all commits
    #
    # @return [Array] Commits in a repo.
    def commits
      if @commits.empty?
        @client.commits(@project_id).auto_paginate do |new_commit|
          new_commit = stringify_keys_deep(new_commit.to_hash)
          new_commit['sha'] = new_commit['id']
          @commits.push(new_commit)
        end
      end
      @commits
    end

    # Return the oldest commit in a repo
    #
    # @return [Hash] Oldest commit in the gitlab git history.
    def oldest_commit
      commits.last
    end

    # @return [String] Default branch of the repo
    def default_branch
      @default_branch ||= @client.project(@project_id)[:default_branch]
    end

    # Fetch all SHAs occurring in or before a given tag and add them to
    # "shas_in_tag"
    #
    # @param [Array] tags The array of tags.
    # @return [Nil] No return; tags are updated in-place.
    def fetch_tag_shas_async(tags)
      i = 0
      threads = []
      print_in_same_line("Fetching SHAs for tags: #{i}/#{tags.count}\r") if @options[:verbose]

      tags.each_slice(MAX_THREAD_NUMBER) do |tags_slice|
        tags_slice.each do |tag|
          threads << Thread.new do
            # Use oldest commit because comparing two arbitrary tags may be diverged
            commits_in_tag = fetch_compare(oldest_commit["sha"], tag["name"])
            tag["shas_in_tag"] = commits_in_tag["commits"].collect { |commit| commit["sha"] }
            print_in_same_line("Fetching SHAs for tags: #{i + 1}/#{tags.count}") if @options[:verbose]
            i += 1
          end
        end
        threads.each(&:join)
        threads = []
      end

      # to clear line from prev print
      print_empty_line

      Helper.log.info "Fetching SHAs for tags: #{i}"
      nil
    end

    private

    def stringify_keys_deep(indata)
      case indata
      when Array
        indata.map do |value|
          stringify_keys_deep(value)
        end
      when Hash
        indata.each_with_object({}) do |(key, value), output|
          output[key.to_s] = stringify_keys_deep(value)
        end
      else
        indata
      end
    end

    # Exception raised to warn about moved repositories.
    MovedPermanentlyError = Class.new(RuntimeError)


    def extract_request_args(args)
      if args.size == 1 && args.first.is_a?(Hash)
        args.delete_at(0)
      elsif args.size > 1 && args.last.is_a?(Hash)
        args.delete_at(args.length - 1)
      else
        {}
      end
    end

    # This is wrapper with rescue block
    #
    # @return [Object] returns exactly the same, what you put in the block, but wrap it with begin-rescue block
    def check_response
      Retriable.retriable(retry_options) do
        yield
      end
    rescue MovedPermanentlyError => e
      fail_with_message(e, "The repository has moved, update your configuration")
    rescue Gitlab::Error::Forbidden => e
      fail_with_message(e, "Exceeded retry limit")
    rescue Gitlab::Error::Unauthorized => e
      fail_with_message(e, "Error: wrong GitHub token")
    end

    # Presents the exception, and the aborts with the message.
    def fail_with_message(error, message)
      Helper.log.error("#{error.class}: #{error.message}")
      sys_abort(message)
    end

    # Exponential backoff
    def retry_options
      {
        on: [Gitlab::Error::Forbidden],
        tries: MAX_FORBIDDEN_RETRIES,
        base_interval: sleep_base_interval,
        multiplier: 1.0,
        rand_factor: 0.0,
        on_retry: retry_callback
      }
    end

    def sleep_base_interval
      1.0
    end

    def retry_callback
      proc do |exception, try, elapsed_time, next_interval|
        Helper.log.warn("RETRY - #{exception.class}: '#{exception.message}'")
        Helper.log.warn("#{try} tries in #{elapsed_time} seconds and #{next_interval} seconds until the next try")
        Helper.log.warn GH_RATE_LIMIT_EXCEEDED_MSG
        Helper.log.warn @client.rate_limit
      end
    end

    def sys_abort(msg)
      abort(msg)
    end

    # Print specified line on the same string
    #
    # @param [String] log_string
    def print_in_same_line(log_string)
      print log_string + "\r"
    end

    # Print long line with spaces on same line to clear prev message
    def print_empty_line
      print_in_same_line("                                                                       ")
    end

    # Returns GitHub token. First try to use variable, provided by --token option,
    # otherwise try to fetch it from CHANGELOG_GITHUB_TOKEN env variable.
    #
    # @return [String]
    def fetch_github_token
      env_var = @options[:token].presence || ENV["CHANGELOG_GITHUB_TOKEN"]

      Helper.log.warn NO_TOKEN_PROVIDED unless env_var

      env_var
    end

    # @return [String] helper to return Github "user/project"
    def user_project
      "#{@options[:user]}/#{@options[:project]}"
    end

    # Returns Hash of all querystring variables in given URI.
    #
    # @param [String] uri eg. https://api.github.com/repositories/43914960/tags?page=37&foo=1
    # @return [Hash] of all GET variables. eg. { 'page' => 37, 'foo' => 1 }
    def querystring_as_hash(uri)
      Hash[URI.decode_www_form(URI(uri).query || "")]
    end
  end
end
