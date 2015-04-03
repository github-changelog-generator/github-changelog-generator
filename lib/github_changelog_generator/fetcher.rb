module GitHubChangelogGenerator
  # A Fetcher responsible for all requests to GitHub and all basic manipulation with related data (such as filtering, validating, e.t.c)
  #
  # Example:
  # fetcher = GitHubChangelogGenerator::Fetcher.new options
  class Fetcher
    def initialize(options = {})
      @options = options

      @user = @options[:user]
      @project = @options[:project]
      @github_token = fetch_github_token

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
  end
end
