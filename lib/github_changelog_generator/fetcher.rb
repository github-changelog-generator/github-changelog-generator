module GitHubChangelogGenerator
  # A Fetcher responsible for all requests to GitHub and all basic manipulation with related data
  # (such as filtering, validating, e.t.c)
  #
  # Example:
  # fetcher = GitHubChangelogGenerator::Fetcher.new options

  class Fetcher
    PER_PAGE_NUMBER = 30
    CHANGELOG_GITHUB_TOKEN = "CHANGELOG_GITHUB_TOKEN"
    GH_RATE_LIMIT_EXCEEDED_MSG = "Warning: Can't finish operation: GitHub API rate limit exceeded, change log may be " \
    "missing some issues. You can limit the number of issues fetched using the `--max-issues NUM` argument."
    NO_TOKEN_PROVIDED = "Warning: No token provided (-t option) and variable $CHANGELOG_GITHUB_TOKEN was not found. " \
    "This script can make only 50 requests to GitHub API per hour without token!"

    def initialize(options = {})
      @options = options || {}
      @user = @options[:user]
      @project = @options[:project]
      @github_token = fetch_github_token
      @github_options = { per_page: PER_PAGE_NUMBER }
      @github_options[:oauth_token] = @github_token unless @github_token.nil?
      @github_options[:endpoint] = @options[:github_endpoint] unless @options[:github_endpoint].nil?
      @github_options[:site] = @options[:github_endpoint] unless @options[:github_site].nil?

      @github = check_github_response { Github.new @github_options }
    end

    # Returns GitHub token. First try to use variable, provided by --token option,
    # otherwise try to fetch it from CHANGELOG_GITHUB_TOKEN env variable.
    #
    # @return [String]
    def fetch_github_token
      env_var = @options[:token] ? @options[:token] : (ENV.fetch CHANGELOG_GITHUB_TOKEN, nil)

      Helper.log.warn NO_TOKEN_PROVIDED.yellow unless env_var

      env_var
    end

    # Fetch all tags from repo
    # @return [Array] array of tags
    def get_all_tags
      print "Fetching tags...\r" if @options[:verbose]

      check_github_response { github_fetch_tags }
    end

    # This is wrapper with rescue block
    # @return [Object] returns exactly the same, what you put in the block, but wrap it with begin-rescue block
    def check_github_response
      begin
        value = yield
      rescue Github::Error::Unauthorized => e
        Helper.log.error e.body.red
        abort "Error: wrong GitHub token"
      rescue Github::Error::Forbidden => e
        Helper.log.warn e.body.red
        Helper.log.warn GH_RATE_LIMIT_EXCEEDED_MSG.yellow
      end
      value
    end

    # Fill input array with tags
    # @return [Array] array of tags in repo
    def github_fetch_tags
      tags = []
      response = @github.repos.tags @options[:user], @options[:project]
      page_i = 0
      count_pages = response.count_pages

      response.each_page do |page|

        if @options[:exclude_tags_filter]
          body_new = []
          reg = Regexp.new @options[:exclude_tags_filter]
          page.body.each do |tag|
            if !(tag.name =~ reg)
              body_new << tag
            end
          end
          page.body = body_new
        end

        page_i += PER_PAGE_NUMBER
        print_in_same_line("Fetching tags... #{page_i}/#{count_pages * PER_PAGE_NUMBER}")
        tags.concat(page)
      end

      print_empty_line

      if tags.count == 0
        Helper.log.warn "Warning: Can't find any tags in repo.\
Make sure, that you push tags to remote repo via 'git push --tags'".yellow
      else
        Helper.log.info "Found #{tags.count} tags"
      end
      tags
    end

    # This method fetch all closed issues and separate them to pull requests and pure issues
    # (pull request is kind of issue in term of GitHub)
    # @return [Tuple] with (issues, pull-requests)
    def fetch_closed_issues_and_pr
      print "Fetching closed issues...\r" if @options[:verbose]
      issues = []

      begin
        response = @github.issues.list user: @options[:user],
                                       repo: @options[:project],
                                       state: "closed",
                                       filter: "all",
                                       labels: nil
        page_i = 0
        count_pages = response.count_pages
        response.each_page do |page|
          page_i += PER_PAGE_NUMBER
          print_in_same_line("Fetching issues... #{page_i}/#{count_pages * PER_PAGE_NUMBER}")
          issues.concat(page)
          break if @options[:max_issues] && issues.length >= @options[:max_issues]
        end
        print_empty_line
        Helper.log.info "Received issues: #{issues.count}"

      rescue
        Helper.log.warn GH_RATE_LIMIT_EXCEEDED_MSG.yellow
      end

      # separate arrays of issues and pull requests:
      issues.partition do |x|
        x[:pull_request].nil?
      end
    end

    # Fetch all pull requests. We need them to detect :merged_at parameter
    # @return [Array] all pull requests
    def fetch_closed_pull_requests
      pull_requests = []
      begin
        if @options[:release_branch].nil?
          response = @github.pull_requests.list @options[:user],
                                                @options[:project],
                                                state: "closed"
        else
          response = @github.pull_requests.list @options[:user],
                                                @options[:project],
                                                state: "closed",
                                                base: @options[:release_branch]
        end
        page_i = 0
        count_pages = response.count_pages
        response.each_page do |page|
          page_i += PER_PAGE_NUMBER
          log_string = "Fetching merged dates... #{page_i}/#{count_pages * PER_PAGE_NUMBER}"
          print_in_same_line(log_string)
          pull_requests.concat(page)
        end
        print_empty_line
      rescue
        Helper.log.warn GH_RATE_LIMIT_EXCEEDED_MSG.yellow
      end

      Helper.log.info "Fetching merged dates: #{pull_requests.count}"
      pull_requests
    end

    # Print specified line on the same string
    # @param [String] log_string
    def print_in_same_line(log_string)
      print log_string + "\r"
    end

    # Print long line with spaces on same line to clear prev message
    def print_empty_line
      print_in_same_line("                                                                       ")
    end

    # Fetch event for all issues and add them to :events
    # @param [Array] issues
    # @return [Void]
    def fetch_events_async(issues)
      i = 0
      max_thread_number = 50
      threads = []
      issues.each_slice(max_thread_number) do |issues_slice|
        issues_slice.each do |issue|
          threads << Thread.new do
            begin
              response = @github.issues.events.list user: @options[:user],
                                                    repo: @options[:project],
                                                    issue_number: issue["number"]
              issue[:events] = []
              response.each_page do |page|
                issue[:events].concat(page)
              end
            rescue
              Helper.log.warn GH_RATE_LIMIT_EXCEEDED_MSG.yellow
            end
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
    # @param [Hash] tag
    # @return [Time] time of specified tag
    def fetch_date_of_tag(tag)
      begin
        commit_data = @github.git_data.commits.get @options[:user],
                                                   @options[:project],
                                                   tag["commit"]["sha"]
      rescue
        Helper.log.warn GH_RATE_LIMIT_EXCEEDED_MSG.yellow
      end
      time_string = commit_data["committer"]["date"]
      Time.parse(time_string)
    end

    # Fetch commit for specified event
    # @return [Hash]
    def fetch_commit(event)
      @github.git_data.commits.get @options[:user], @options[:project], event[:commit_id]
    end
  end
end
