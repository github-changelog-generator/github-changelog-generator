# frozen_string_literal: true

require "tmpdir"
require "set"
require "async"
require "async/barrier"
require "async/semaphore"
require "async/http/faraday"

module GitHubChangelogGenerator
  # A Fetcher responsible for all requests to GitHub and all basic manipulation with related data
  # (such as filtering, validating, e.t.c)
  #
  # Example:
  # fetcher = GitHubChangelogGenerator::OctoFetcher.new(options)
  class OctoFetcher
    PER_PAGE_NUMBER = 100
    MAXIMUM_CONNECTIONS = 50
    MAX_FORBIDDEN_RETRIES = 100
    CHANGELOG_GITHUB_TOKEN = "CHANGELOG_GITHUB_TOKEN"
    GH_RATE_LIMIT_EXCEEDED_MSG = "Warning: Can't finish operation: GitHub API rate limit exceeded, changelog may be " \
    "missing some issues. You can limit the number of issues fetched using the `--max-issues NUM` argument."
    NO_TOKEN_PROVIDED = "Warning: No token provided (-t option) and variable $CHANGELOG_GITHUB_TOKEN was not found. " \
    "This script can make only 50 requests to GitHub API per hour without a token!"

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
      @commits      = []
      @branches     = nil
      @graph        = nil
      @client = nil
      @commits_in_tag_cache = {}
    end

    def middleware
      Faraday::RackBuilder.new do |builder|
        if @http_cache
          cache_file = @options.fetch(:cache_file) { File.join(Dir.tmpdir, "github-changelog-http-cache") }
          cache_log  = @options.fetch(:cache_log) { File.join(Dir.tmpdir, "github-changelog-logger.log") }

          builder.use(
            Faraday::HttpCache,
            serializer: Marshal,
            store: ActiveSupport::Cache::FileStore.new(cache_file),
            logger: Logger.new(cache_log),
            shared_cache: false
          )
        end

        builder.use Octokit::Response::RaiseError
        builder.adapter :async_http
      end
    end

    def connection_options
      ca_file = @options[:ssl_ca_file] || ENV["SSL_CA_FILE"] || File.expand_path("ssl_certs/cacert.pem", __dir__)

      Octokit.connection_options.merge({ ssl: { ca_file: ca_file } })
    end

    def client_options
      options = {
        middleware: middleware,
        connection_options: connection_options
      }

      if (github_token = fetch_github_token)
        options[:access_token] = github_token
      end

      if (endpoint = @options[:github_endpoint])
        options[:api_endpoint] = endpoint
      end

      options
    end

    def client
      @client ||= Octokit::Client.new(client_options)
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
    # @param [Object] request_options
    # @param [Object] method
    # @param [Object] client
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
      tags = []
      page_i = 0
      count_pages = calculate_pages(client, "tags", {})

      iterate_pages(client, "tags") do |new_tags|
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
      page_i = 0
      count_pages = calculate_pages(client, "issues", closed_pr_options)

      iterate_pages(client, "issues", **closed_pr_options) do |new_issues|
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

      page_i = 0
      count_pages = calculate_pages(client, "pull_requests", options)

      iterate_pages(client, "pull_requests", **options) do |new_pr|
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
      i = 0
      # Add accept option explicitly for disabling the warning of preview API.
      preview = { accept: Octokit::Preview::PREVIEW_TYPES[:project_card_events] }

      barrier = Async::Barrier.new
      semaphore = Async::Semaphore.new(MAXIMUM_CONNECTIONS, parent: barrier)

      Sync do
        client = self.client

        issues.each do |issue|
          semaphore.async do
            issue["events"] = []
            iterate_pages(client, "issue_events", issue["number"], **preview) do |new_event|
              issue["events"].concat(new_event)
            end
            issue["events"] = issue["events"].map { |event| stringify_keys_deep(event.to_hash) }
            print_in_same_line("Fetching events for issues and PR: #{i + 1}/#{issues.count}")
            i += 1
          end
        end

        barrier.wait

        # to clear line from prev print
        print_empty_line
      end

      Helper.log.info "Fetching events for issues and PR: #{i}"
    end

    # Fetch comments for PRs and add them to "comments"
    #
    # @param [Array] prs The array of PRs.
    # @return [Void] No return; PRs are updated in-place.
    def fetch_comments_async(prs)
      barrier = Async::Barrier.new
      semaphore = Async::Semaphore.new(MAXIMUM_CONNECTIONS, parent: barrier)

      Sync do
        client = self.client

        prs.each do |pr|
          semaphore.async do
            pr["comments"] = []
            iterate_pages(client, "issue_comments", pr["number"]) do |new_comment|
              pr["comments"].concat(new_comment)
            end
            pr["comments"] = pr["comments"].map { |comment| stringify_keys_deep(comment.to_hash) }
          end
        end

        barrier.wait
      end

      nil
    end

    # Fetch tag time from repo
    #
    # @param [Hash] tag GitHub data item about a Tag
    #
    # @return [Time] time of specified tag
    def fetch_date_of_tag(tag)
      commit_data = fetch_commit(tag["commit"]["sha"])
      commit_data = stringify_keys_deep(commit_data.to_hash)

      commit_data["commit"]["committer"]["date"]
    end

    # Fetch commit for specified event
    #
    # @param [String] commit_id the SHA of a commit to fetch
    # @return [Hash]
    def fetch_commit(commit_id)
      found = commits.find do |commit|
        commit["sha"] == commit_id
      end
      if found
        stringify_keys_deep(found.to_hash)
      else
        client = self.client

        # cache miss; don't add to @commits because unsure of order.
        check_github_response do
          commit = client.commit(user_project, commit_id)
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
        Sync do
          barrier = Async::Barrier.new
          semaphore = Async::Semaphore.new(MAXIMUM_CONNECTIONS, parent: barrier)

          if (since_commit = @options[:since_commit])
            iterate_pages(client, "commits_since", since_commit, parent: semaphore) do |new_commits|
              @commits.concat(new_commits)
            end
          else
            iterate_pages(client, "commits", parent: semaphore) do |new_commits|
              @commits.concat(new_commits)
            end
          end

          barrier.wait

          @commits.sort! do |b, a|
            a[:commit][:author][:date] <=> b[:commit][:author][:date]
          end
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

    # @return [String] Default branch of the repo
    def default_branch
      @default_branch ||= client.repository(user_project)[:default_branch]
    end

    # @param [String] name
    # @return [Array<String>]
    def commits_in_branch(name)
      @branches ||= client.branches(user_project).map { |branch| [branch[:name], branch] }.to_h

      if (branch = @branches[name])
        commits_in_tag(branch[:commit][:sha])
      else
        []
      end
    end

    # Fetch all SHAs occurring in or before a given tag and add them to
    # "shas_in_tag"
    #
    # @param [Array] tags The array of tags.
    # @return void
    def fetch_tag_shas(tags)
      # Reverse the tags array to gain max benefit from the @commits_in_tag_cache
      tags.reverse_each do |tag|
        tag["shas_in_tag"] = commits_in_tag(tag["commit"]["sha"])
      end
    end

    private

    # @param [Set] shas
    # @param [Object] sha
    def commits_in_tag(sha, shas = Set.new)
      # Reduce multiple runs for the same tag
      return @commits_in_tag_cache[sha] if @commits_in_tag_cache.key?(sha)

      @graph ||= commits.map { |commit| [commit[:sha], commit] }.to_h
      return shas unless (current = @graph[sha])

      queue = [current]
      while queue.any?
        commit = queue.shift
        # If we've already processed this sha, just grab it's parents from the cache
        if @commits_in_tag_cache.key?(commit[:sha])
          shas.merge(@commits_in_tag_cache[commit[:sha]])
        else
          shas.add(commit[:sha])
          commit[:parents].each do |p|
            queue.push(@graph[p[:sha]]) unless shas.include?(p[:sha])
          end
        end
      end

      @commits_in_tag_cache[sha] = shas
      shas
    end

    # @param [Object] indata
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
    # @param [Array] arguments
    # @param [Async::Semaphore] parent
    #
    # @yield [Sawyer::Resource] An OctoKit-provided response (which can be empty)
    #
    # @return [void]
    # @param [Hash] options
    def iterate_pages(client, method, *arguments, parent: nil, **options)
      options = DEFAULT_REQUEST_OPTIONS.merge(options)

      check_github_response { client.send(method, user_project, *arguments, **options) }
      last_response = client.last_response.tap do |response|
        raise(MovedPermanentlyError, response.data[:url]) if response.status == 301
      end

      yield(last_response.data)

      if parent.nil?
        # The snail visits one leaf at a time:
        until (next_one = last_response.rels[:next]).nil?
          last_response = check_github_response { next_one.get }
          yield(last_response.data)
        end
      elsif (last = last_response.rels[:last])
        # OR we bring out the gatling gun:
        parameters = querystring_as_hash(last.href)
        last_page = Integer(parameters["page"])

        (2..last_page).each do |page|
          parent.async do
            data = check_github_response { client.send(method, user_project, *arguments, page: page, **options) }
            yield data
          end
        end
      end
    end

    # This is wrapper with rescue block
    #
    # @return [Object] returns exactly the same, what you put in the block, but wrap it with begin-rescue block
    # @param [Proc] block
    def check_github_response
      yield
    rescue MovedPermanentlyError => e
      fail_with_message(e, "The repository has moved, update your configuration")
    rescue Octokit::TooManyRequests => e
      resets_in = client.rate_limit.resets_in
      Helper.log.error("#{e.class} #{e.message}; sleeping for #{resets_in}s...")

      if (task = Async::Task.current?)
        task.sleep(resets_in)
      else
        sleep(resets_in)
      end

      retry
    rescue Octokit::Forbidden => e
      fail_with_message(e, "Exceeded retry limit")
    rescue Octokit::Unauthorized => e
      fail_with_message(e, "Error: wrong GitHub token")
    end

    # Presents the exception, and the aborts with the message.
    # @param [Object] message
    # @param [Object] error
    def fail_with_message(error, message)
      Helper.log.error("#{error.class}: #{error.message}")
      sys_abort(message)
    end

    # @param [Object] msg
    def sys_abort(msg)
      abort(msg)
    end

    # Print specified line on the same string
    #
    # @param [String] log_string
    def print_in_same_line(log_string)
      print "#{log_string}\r"
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
