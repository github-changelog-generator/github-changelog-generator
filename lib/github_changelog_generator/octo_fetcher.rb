# frozen_string_literal: true

require "tmpdir"
require "retriable"
module GitHubChangelogGenerator
  # A Fetcher responsible for all requests to GitHub and all basic manipulation with related data
  # (such as filtering, validating, e.t.c)
  #
  # Example:
  # fetcher = GitHubChangelogGenerator::OctoFetcher.new(options)
  class OctoFetcher
    PER_PAGE_NUMBER   = 100
    MAX_THREAD_NUMBER = 25
    MAX_FORBIDDEN_RETRIES = 100
    CHANGELOG_GITHUB_TOKEN = "CHANGELOG_GITHUB_TOKEN"
    GH_RATE_LIMIT_EXCEEDED_MSG = "Warning: Can't finish operation: GitHub API rate limit exceeded, changelog may be " \
    "missing some issues. You can limit the number of issues fetched using the `--max-issues NUM` argument."
    NO_TOKEN_PROVIDED = "Warning: No token provided (-t option) and variable $CHANGELOG_GITHUB_TOKEN was not found. " \
    "This script can make only 50 requests to GitHub API per hour without token!"

    # @param options [Hash] Options passed in
    # @option options [String] :user GitHub username
    # @option options [String] :project GitHub project
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
      prepare_cache
      configure_octokit_ssl
      @client = Octokit::Client.new(github_options)
    end

    def prepare_cache
      return unless @http_cache
      @cache_file = @options.fetch(:cache_file) { File.join(Dir.tmpdir, "github-changelog-http-cache") }
      @cache_log  = @options.fetch(:cache_log) { File.join(Dir.tmpdir, "github-changelog-logger.log") }
      init_cache
    end

    def github_options
      result = {}
      github_token = fetch_github_token
      result[:access_token] = github_token if github_token
      endpoint = @options[:github_endpoint]
      result[:api_endpoint] = endpoint if endpoint
      result
    end

    def configure_octokit_ssl
      ca_file = @options[:ssl_ca_file] || ENV["SSL_CA_FILE"] || File.expand_path("ssl_certs/cacert.pem", __dir__)
      Octokit.connection_options = { ssl: { ca_file: ca_file } }
    end

    def init_cache
      Octokit.middleware = Faraday::RackBuilder.new do |builder|
        builder.use(Faraday::HttpCache, serializer: Marshal,
                                        store: ActiveSupport::Cache::FileStore.new(@cache_file),
                                        logger: Logger.new(@cache_log),
                                        shared_cache: false)
        builder.use Octokit::Response::RaiseError
        builder.adapter Faraday.default_adapter
        # builder.response :logger
      end
    end

    DEFAULT_REQUEST_OPTIONS = { per_page: PER_PAGE_NUMBER }

    # Fetch all tags from repo
    #
    # @return [Array <Hash>] array of tags
    def get_all_tags
      print "Fetching tags...\r" if @options[:verbose]

      check_github_response { github_fetch_tags }
    end

    # Returns the number of pages for a API call
    #
    # @return [Integer] number of pages for this API call in total
    def calculate_pages(client, method, request_options)
      # Makes the first API call so that we can call last_response
      check_github_response do
        client.send(method, user_project, DEFAULT_REQUEST_OPTIONS.merge(request_options))
      end

      last_response = client.last_response

      if (last_pg = last_response.rels[:last])
        querystring_as_hash(last_pg.href)["page"].to_i
      else
        1
      end
    end

    # Fill input array with tags
    #
    # @return [Array <Hash>] array of tags in repo
    def github_fetch_tags
      tags        = []
      page_i      = 0
      count_pages = calculate_pages(@client, "tags", {})

      iterate_pages(@client, "tags") do |new_tags|
        page_i += PER_PAGE_NUMBER
        print_in_same_line("Fetching tags... #{page_i}/#{count_pages * PER_PAGE_NUMBER}")
        tags.concat(new_tags)
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
        filter: "all", labels: nil, state: "closed"
      }.tap { |options| options[:since] = @since if @since }
    end

    # This method fetch all closed issues and separate them to pull requests and pure issues
    # (pull request is kind of issue in term of GitHub)
    #
    # @return [Tuple] with (issues [Array <Hash>], pull-requests [Array <Hash>])
    def fetch_closed_issues_and_pr
      print "Fetching closed issues...\r" if @options[:verbose]
      issues = []
      page_i      = 0
      count_pages = calculate_pages(@client, "issues", closed_pr_options)

      iterate_pages(@client, "issues", closed_pr_options) do |new_issues|
        page_i += PER_PAGE_NUMBER
        print_in_same_line("Fetching issues... #{page_i}/#{count_pages * PER_PAGE_NUMBER}")
        issues.concat(new_issues)
        break if @options[:max_issues] && issues.length >= @options[:max_issues]
      end
      print_empty_line
      Helper.log.info "Received issues: #{issues.count}"

      # separate arrays of issues and pull requests:
      issues.map { |issue| stringify_keys_deep(issue.to_hash) }
            .partition { |issue_or_pr| issue_or_pr["pull_request"].nil? }
    end

    # Fetch all pull requests. We need them to detect :merged_at parameter
    #
    # @return [Array <Hash>] all pull requests
    def fetch_closed_pull_requests
      pull_requests = []
      options = { state: "closed" }

      unless @options[:release_branch].nil?
        options[:base] = @options[:release_branch]
      end

      page_i      = 0
      count_pages = calculate_pages(@client, "pull_requests", options)

      iterate_pages(@client, "pull_requests", options) do |new_pr|
        page_i += PER_PAGE_NUMBER
        log_string = "Fetching merged dates... #{page_i}/#{count_pages * PER_PAGE_NUMBER}"
        print_in_same_line(log_string)
        pull_requests.concat(new_pr)
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
            iterate_pages(@client, "issue_events", issue["number"]) do |new_event|
              issue["events"].concat(new_event)
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

    # Fetch tag time from repo
    #
    # @param [Hash] tag GitHub data item about a Tag
    #
    # @return [Time] time of specified tag
    def fetch_date_of_tag(tag)
      commit_data = check_github_response { @client.commit(user_project, tag["commit"]["sha"]) }
      commit_data = stringify_keys_deep(commit_data.to_hash)

      commit_data["commit"]["committer"]["date"]
    end

    # Fetch and cache comparison between two github refs
    #
    # @param [String] older The older sha/tag/branch.
    # @param [String] newer The newer sha/tag/branch.
    # @return [Hash] Github api response for comparison.
    def fetch_compare(older, newer)
      unless @compares["#{older}...#{newer}"]
        compare_data = check_github_response { @client.compare(user_project, older, newer || "HEAD") }
        raise StandardError, "Sha #{older} and sha #{newer} are not related; please file a github-changelog-generator issues and describe how to replicate this issue." if compare_data["status"] == "diverged"
        @compares["#{older}...#{newer}"] = stringify_keys_deep(compare_data.to_hash)
      end
      @compares["#{older}...#{newer}"]
    end

    # Fetch commit for specified event
    #
    # @return [Hash]
    def fetch_commit(event)
      found = commits.find do |commit|
        commit["sha"] == event["commit_id"]
      end
      if found
        stringify_keys_deep(found.to_hash)
      else
        # cache miss; don't add to @commits because unsure of order.
        check_github_response do
          commit = @client.commit(user_project, event["commit_id"])
          commit = stringify_keys_deep(commit.to_hash)
          commit
        end
      end
    end

    # Fetch all commits
    #
    # @return [Array] Commits in a repo.
    def commits
      if @commits.empty?
        iterate_pages(@client, "commits") do |new_commits|
          @commits.concat(new_commits)
        end
      end
      @commits
    end

    # Return the oldest commit in a repo
    #
    # @return [Hash] Oldest commit in the github git history.
    def oldest_commit
      commits.last
    end

    # Adds a key "first_occurring_tag" to each PR with a value of the oldest
    # tag that a PR's merge commit occurs in in the git history. This should
    # indicate the release of each PR by git's history regardless of dates and
    # divergent branches.
    #
    # @param [Array] tags The array of tags sorted by time, newest to oldest.
    # @param [Array] prs The array of PRs to discover the tags of.
    # @return [Nil] No return; PRs are updated in-place.
    def add_first_occurring_tag_to_prs(tags, prs)
      # Shallow-clone tags and prs to avoid modification of passed arrays.
      # Iterate tags.reverse (oldest to newest) to find first tag of each PR.
      tags = tags.dup.reverse
      prs = prs.dup
      total = prs.length
      while tags.any? && prs.any?
        print_in_same_line("Associating PRs with tags: #{total - prs.length}/#{total}")
        tag = tags.shift
        # Use oldest commit because comparing two arbitrary tags may be diverged
        commits_in_tag = fetch_compare(oldest_commit["sha"], tag["name"])
        shas_in_tag = commits_in_tag["commits"].collect { |commit| commit["sha"] }
        prs = prs.reject do |pr|
          # XXX Wish I could use merge_commit_sha, but gcg doesn't currently
          # fetch that. See https://developer.github.com/v3/pulls/#get-a-single-pull-request
          if pr["events"] && (event = pr["events"].find { |e| e["event"] == "merged" })
            pr_sha = event["commit_id"]
            pr["first_occurring_tag"] = tag["name"] if shas_in_tag.include?(pr_sha)
          else
            raise StandardError, "No merge sha found for PR #{pr['number']}"
          end
        end
      end
      # All tags have been shifted or prs mapped, and as many PRs have been
      # associated with tags as possible. Any remaining PRs are unreleased.
      # Any remaining tags have no known PRs.
      Helper.log.info "Associating PRs with tags: #{total}"
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

    # Iterates through all pages until there are no more :next pages to follow
    # yields the result per page
    #
    # @param [Octokit::Client] client
    # @param [String] method (eg. 'tags')
    #
    # @yield [Sawyer::Resource] An OctoKit-provided response (which can be empty)
    #
    # @return [void]
    def iterate_pages(client, method, *args)
      args << DEFAULT_REQUEST_OPTIONS.merge(extract_request_args(args))

      check_github_response { client.send(method, user_project, *args) }
      last_response = client.last_response.tap do |response|
        raise(MovedPermanentlyError, response.data[:url]) if response.status == 301
      end

      yield(last_response.data)

      until (next_one = last_response.rels[:next]).nil?
        last_response = check_github_response { next_one.get }
        yield(last_response.data)
      end
    end

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
    def check_github_response
      Retriable.retriable(retry_options) do
        yield
      end
    rescue MovedPermanentlyError => e
      fail_with_message(e, "The repository has moved, update your configuration")
    rescue Octokit::Forbidden => e
      fail_with_message(e, "Exceeded retry limit")
    rescue Octokit::Unauthorized => e
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
        on: [Octokit::Forbidden],
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
