module GitHubChangelogGenerator
  # A Fetcher responsible for all requests to GitHub and all basic manipulation with related data (such as filtering, validating, e.t.c)
  #
  # Example:
  # fetcher = GitHubChangelogGenerator::Fetcher.new options
  class Fetcher
    PER_PAGE_NUMBER = 30
    GH_RATE_LIMIT_EXCEEDED_MSG = "Warning: GitHub API rate limit (5000 per hour) exceeded, change log may be " \
        "missing some issues. You can limit the number of issues fetched using the `--max-issues NUM` argument."

    def initialize(options = {})
      @options = options

      @user = @options[:user]
      @project = @options[:project]
      @github_token = fetch_github_token
      @tag_times_hash = {}
      github_options = { per_page: PER_PAGE_NUMBER }
      github_options[:oauth_token] = @github_token unless @github_token.nil?
      github_options[:endpoint] = options[:github_endpoint] unless options[:github_endpoint].nil?
      github_options[:site] = options[:github_endpoint] unless options[:github_site].nil?

      begin
        @github = Github.new github_options
      rescue
        puts GH_RATE_LIMIT_EXCEEDED_MSG.yellow
      end
    end

    # Returns GitHub token. First try to use variable, provided by --token option, otherwise try to fetch it from CHANGELOG_GITHUB_TOKEN env variable.
    #
    # @return [String]
    def fetch_github_token
      env_var = @options[:token] ? @options[:token] : (ENV.fetch "CHANGELOG_GITHUB_TOKEN", nil)

      unless env_var
        puts "Warning: No token provided (-t option) and variable $CHANGELOG_GITHUB_TOKEN was not found.".yellow
        puts "This script can make only 50 requests to GitHub API per hour without token!".yellow
      end

      env_var
    end

    # Fetch all tags from repo
    # @return [Array] array of tags
    def get_all_tags
      if @options[:verbose]
        print "Fetching tags...\r"
      end

      tags = []

      begin
        response = @github.repos.tags @options[:user], @options[:project]
        page_i = 0
        count_pages = response.count_pages
        response.each_page do |page|
          page_i += PER_PAGE_NUMBER
          print "Fetching tags... #{page_i}/#{count_pages * PER_PAGE_NUMBER}\r"
          tags.concat(page)
        end
        print "                               \r"

        if tags.count == 0
          puts "Warning: Can't find any tags in repo. Make sure, that you push tags to remote repo via 'git push --tags'".yellow
        elsif @options[:verbose]
          puts "Found #{tags.count} tags"
        end

      rescue
        puts GH_RATE_LIMIT_EXCEEDED_MSG.yellow
      end

      tags
    end

    # This method fetch all closed issues and separate them to pull requests and pure issues
    # (pull request is kind of issue in term of GitHub)
    # @return [Tuple] with issues and pull requests
    def fetch_issues_and_pull_requests
      if @options[:verbose]
        print "Fetching closed issues...\r"
      end
      issues = []

      begin
        response = @github.issues.list user: @options[:user], repo: @options[:project], state: "closed", filter: "all", labels: nil
        page_i = 0
        count_pages = response.count_pages
        response.each_page do |page|
          page_i += PER_PAGE_NUMBER
          print "Fetching issues... #{page_i}/#{count_pages * PER_PAGE_NUMBER}\r"
          issues.concat(page)
          break if @options[:max_issues] && issues.length >= @options[:max_issues]
        end
      rescue
        puts GH_RATE_LIMIT_EXCEEDED_MSG.yellow
      end

      print "                                                \r"

      if @options[:verbose]
        puts "Received issues: #{issues.count}"
      end

      # remove pull request from issues:
      issues.partition { |x|
        x[:pull_request].nil?
      }
    end

    # Fetch all pull requests. We need them to detect :merged_at parameter
    # @return [Array] all pull requests
    def fetch_pull_requests
      pull_requests = []
      begin
        response = @github.pull_requests.list @options[:user], @options[:project], state: "closed"
        page_i = 0
        response.each_page do |page|
          page_i += PER_PAGE_NUMBER
          count_pages = response.count_pages
          print "Fetching merged dates... #{page_i}/#{count_pages * PER_PAGE_NUMBER}\r"
          pull_requests.concat(page)
        end
      rescue
        puts GH_RATE_LIMIT_EXCEEDED_MSG.yellow
      end

      print "                                                   \r"
      pull_requests
    end

    # Fetch event for all issues and add them to :events
    # @param [Array] issues
    # @return [Void]
    def fetch_events_async(issues)
      i = 0
      max_thread_number = 50
      threads = []
      issues.each_slice(max_thread_number) { |issues_slice|
        issues_slice.each { |issue|
          threads << Thread.new {
            begin
              obj = @github.issues.events.list user: @options[:user], repo: @options[:project], issue_number: issue["number"]
            rescue
              puts GH_RATE_LIMIT_EXCEEDED_MSG.yellow
            end
            issue[:events] = obj.body
            print "Fetching events for issues and PR: #{i + 1}/#{issues.count}\r"
            i += 1
          }
        }
        threads.each(&:join)
        threads = []
      }

      # to clear line from prev print
      print "                                                            \r"

      if @options[:verbose]
        puts "Fetching events for issues and PR: #{i} Done!"
      end
    end

    # Try to find tag date in local hash.
    # Otherwise fFetch tag time and put it to local hash file.
    # @param [String] tag_name name of the tag
    # @return [Time] time of specified tag
    def get_time_of_tag(tag_name)
      fail ChangelogGeneratorError, "tag_name is nil".red if tag_name.nil?

      if @tag_times_hash[tag_name["name"]]
        return @tag_times_hash[tag_name["name"]]
      end

      begin
        github_git_data_commits_get = @github.git_data.commits.get @options[:user], @options[:project], tag_name["commit"]["sha"]
      rescue
        puts GH_RATE_LIMIT_EXCEEDED_MSG.yellow
      end
      time_string = github_git_data_commits_get["committer"]["date"]
      @tag_times_hash[tag_name["name"]] = Time.parse(time_string)
    end

    # Fetch commit for specifed event
    # @return [Hash]
    def fetch_commit(event)
      @github.git_data.commits.get @options[:user], @options[:project], event[:commit_id]
    end
  end
end
