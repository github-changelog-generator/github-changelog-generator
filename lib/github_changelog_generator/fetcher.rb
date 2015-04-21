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

      github_options = {per_page: PER_PAGE_NUMBER}
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

    # Return tags after filtering tags in lists provided by option: --between-tags & --exclude-tags
    #
    # @return [Array]
    def get_filtered_tags
      all_tags = get_all_tags
      filtered_tags = []
      if @options[:between_tags]
        @options[:between_tags].each do |tag|
          unless all_tags.include? tag
            puts "Warning: can't find tag #{tag}, specified with --between-tags option.".yellow
          end
        end
        filtered_tags = all_tags.select { |tag| @options[:between_tags].include? tag }
      end
      filtered_tags
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


    # This method fetch missing required attributes for pull requests
    # :merged_at - is a date, when issue PR was merged.
    # More correct to use this date, not closed date.
    def fetch_merged_at_pull_requests
      if @options[:verbose]
        print "Fetching merged dates...\r"
      end
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

      @pull_requests.each { |pr|
        fetched_pr = pull_requests.find { |fpr|
          fpr.number == pr.number
        }
        pr[:merged_at] = fetched_pr[:merged_at]
        pull_requests.delete(fetched_pr)
      }

      if @options[:verbose]
        puts "Fetching merged dates: Done!"
      end
    end

  end
end
