# frozen_string_literal: true
module GitHubChangelogGenerator
  # A Fetcher responsible for all requests to GitHub and all basic manipulation with related data
  # (such as filtering, validating, e.t.c)
  #
  # Example:
  # fetcher = GitHubChangelogGenerator::OctoFetcher.new(options)
  class OctoFetcher
    PER_PAGE_NUMBER   = 100
    MAX_THREAD_NUMBER = 25
    CHANGELOG_GITHUB_TOKEN = "CHANGELOG_GITHUB_TOKEN"
    GH_RATE_LIMIT_EXCEEDED_MSG = "Warning: Can't finish operation: GitHub API rate limit exceeded, change log may be " \
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
    def initialize(options = {}) # rubocop:disable Metrics/CyclomaticComplexity
      @options      = options || {}
      @user         = @options[:user]
      @project      = @options[:project]
      @since        = @options[:since]
      @http_cache   = @options[:http_cache]
      @cache_file   = @options.fetch(:cache_file, "/tmp/github-changelog-http-cache") if @http_cache
      @cache_log    = @options.fetch(:cache_log, "/tmp/github-changelog-logger.log") if @http_cache
      init_cache if @http_cache

      @github_token = fetch_github_token

      @request_options               = { per_page: PER_PAGE_NUMBER }
      @github_options                = {}
      @github_options[:access_token] = @github_token unless @github_token.nil?
      @github_options[:api_endpoint] = @options[:github_endpoint] unless @options[:github_endpoint].nil?

      client_type = @options[:github_endpoint].nil? ? Octokit::Client : Octokit::EnterpriseAdminClient
      @client     = client_type.new(@github_options)
    end

    def init_cache
      middleware_opts = {
        serializer: Marshal,
        store: ActiveSupport::Cache::FileStore.new(@cache_file),
        logger: Logger.new(@cache_log),
        shared_cache: false
      }
      stack = Faraday::RackBuilder.new do |builder|
        builder.use Faraday::HttpCache, middleware_opts
        builder.use Octokit::Response::RaiseError
        builder.adapter Faraday.default_adapter
        # builder.response :logger
      end
      Octokit.middleware = stack
    end

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
        client.send(method, user_project, @request_options.merge(request_options))
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

      iterate_pages(@client, "tags", {}) do |new_tags|
        page_i += PER_PAGE_NUMBER
        print_in_same_line("Fetching tags... #{page_i}/#{count_pages * PER_PAGE_NUMBER}")
        tags.concat(new_tags)
      end
      print_empty_line

      if tags.count == 0
        Helper.log.warn "Warning: Can't find any tags in repo.\
Make sure, that you push tags to remote repo via 'git push --tags'"
      else
        Helper.log.info "Found #{tags.count} tags"
      end
      # tags are a Sawyer::Resource. Convert to hash
      tags = tags.map { |h| stringify_keys_deep(h.to_hash) }
      tags
    end

    # This method fetch all closed issues and separate them to pull requests and pure issues
    # (pull request is kind of issue in term of GitHub)
    #
    # @return [Tuple] with (issues [Array <Hash>], pull-requests [Array <Hash>])
    def fetch_closed_issues_and_pr
      print "Fetching closed issues...\r" if @options[:verbose]
      issues = []
      options = {
        state: "closed",
        filter: "all",
        labels: nil
      }
      options[:since] = @since unless @since.nil?

      page_i      = 0
      count_pages = calculate_pages(@client, "issues", options)

      iterate_pages(@client, "issues", options) do |new_issues|
        page_i += PER_PAGE_NUMBER
        print_in_same_line("Fetching issues... #{page_i}/#{count_pages * PER_PAGE_NUMBER}")
        issues.concat(new_issues)
        break if @options[:max_issues] && issues.length >= @options[:max_issues]
      end
      print_empty_line
      Helper.log.info "Received issues: #{issues.count}"

      issues = issues.map { |h| stringify_keys_deep(h.to_hash) }

      # separate arrays of issues and pull requests:
      issues.partition do |x|
        x["pull_request"].nil?
      end
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
      pull_requests = pull_requests.map { |h| stringify_keys_deep(h.to_hash) }
      pull_requests
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
            iterate_pages(@client, "issue_events", issue["number"], {}) do |new_event|
              issue["events"].concat(new_event)
            end
            issue["events"] = issue["events"].map { |h| stringify_keys_deep(h.to_hash) }
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

    # Fetch commit for specified event
    #
    # @return [Hash]
    def fetch_commit(event)
      check_github_response do
        commit = @client.commit(user_project, event["commit_id"])
        commit = stringify_keys_deep(commit.to_hash)
        commit
      end
    end

    private

    def stringify_keys_deep(indata)
      case indata
      when Array
        indata.map do |value|
          stringify_keys_deep(value)
        end
      when Hash
        indata.each_with_object({}) do |(k, v), output|
          output[k.to_s] = stringify_keys_deep(v)
        end
      else
        indata
      end
    end

    # Iterates through all pages until there are no more :next pages to follow
    # yields the result per page
    #
    # @param [Octokit::Client] client
    # @param [String] method (eg. 'tags')
    # @return [Integer] total number of pages
    def iterate_pages(client, method, *args)
      if args.size == 1 && args.first.is_a?(Hash)
        request_options = args.delete_at(0)
      elsif args.size > 1 && args.last.is_a?(Hash)
        request_options = args.delete_at(args.length - 1)
      end

      args.push(@request_options.merge(request_options))

      pages = 1

      check_github_response do
        client.send(method, user_project, *args)
      end
      last_response = client.last_response

      yield last_response.data

      until (next_one = last_response.rels[:next]).nil?
        pages += 1

        last_response = check_github_response { next_one.get }
        yield last_response.data
      end

      pages
    end

    # This is wrapper with rescue block
    #
    # @return [Object] returns exactly the same, what you put in the block, but wrap it with begin-rescue block
    def check_github_response
      begin
        value = yield
      rescue Octokit::Unauthorized => e
        Helper.log.error e.message
        abort "Error: wrong GitHub token"
      rescue Octokit::Forbidden => e
        Helper.log.warn e.message
        Helper.log.warn GH_RATE_LIMIT_EXCEEDED_MSG
        Helper.log.warn @client.rate_limit
      end
      value
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
      env_var = @options[:token] ? @options[:token] : (ENV.fetch CHANGELOG_GITHUB_TOKEN, nil)

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
