# frozen_string_literal: true
module GitHubChangelogGenerator
  class ProjectNameFinder
    attr_reader :options, :args

    # @param options [Options]
    # @param args [Array] ARGV or the empty list.
    #                     The first element of this argument takes two forms:
    #                     Either a full GitHub URL, or a 'username/projectname',
    #                     or simply a GitHub username.
    #                     If the first element is given as a username,
    #                     then the second element can be given as a projectname.
    def initialize(options, args)
      @options = options
      @args = args
    end

    FIXED_TEST_PROJECT = %w(skywinder changelog_test)

    NO_MATCHING_USER_AND_PROJECT = [nil, nil]

    # Returns a tuple of user and project from CLI arguments or git remote.
    #
    # @return [Array<String>] user and project, or nil if unsuccessful
    def call
      [
        -> { from_cli_option },
        -> { FIXED_TEST_PROJECT if in_development? },
        -> { from_git_remote }
      ].find(proc { NO_MATCHING_USER_AND_PROJECT }) do |strategy|
        user, project = strategy.call
        break [user, project] if user && project
      end
    end

    def in_development?
      ENV["RUBYLIB"] =~ /ruby-debug-ide/
    end

    # Returns GitHub username and project from CLI arguments
    #
    # @return [Array, nil] user and project, or nil if unsuccessful
    def from_cli_option
      if args[0] && !args[1]
        github_site_pattern =~ args.first

        begin
          param = Regexp.last_match(2).nil?
        rescue
          puts "Can't detect user and name from first parameter: '#{args.first}' -> exit'"
          return
        end
        if param
          return NO_MATCHING_USER_AND_PROJECT
        else
          [Regexp.last_match(:user), Regexp.last_match(:project)]
        end
      end
    end

    # This pattern matches strings such as:
    #
    # "https://github.com/skywinder/Github-Changelog-Generator"
    #
    # or
    #
    # "skywinder/Github-Changelog-Generator"
    #
    # to user and name.
    def github_site_pattern
      /(?:.*#{Regexp.quote(github_site)}\/)?(?<user>(.+))\/(?<project>(.+))/
    end

    # These patterns match these formats:
    #
    # ```
    # origin	git@github.com:skywinder/Github-Changelog-Generator.git (fetch)
    # git@github.com:skywinder/Github-Changelog-Generator.git
    # ```
    #
    # and
    #
    # ```
    # origin	https://github.com/skywinder/ChangelogMerger (fetch)
    # https://github.com/skywinder/ChangelogMerger
    # ```
    GIT_REMOTE_PATTERNS = [
      /.*(?:[:\/])(?<user>(?:-|\w|\.)*)\/(?<project>(?:-|\w|\.)*)(?:\.git).*/,
      /.*\/(?<user>(?:-|\w|\.)*)\/(?<project>(?:-|\w|\.)*).*/
    ]

    # Returns GitHub username and project from git remote output
    #
    # @return [Array] user and project
    def from_git_remote
      GIT_REMOTE_PATTERNS.find(proc { NO_MATCHING_USER_AND_PROJECT }) do |git_remote_pattern|
        git_remote_pattern =~ git_remote_content

        if Regexp.last_match
          break [Regexp.last_match(:user), Regexp.last_match(:project)]
        end
      end
    end

    # @return [String] Output of git remote command
    def git_remote_content
      @git_remote_content ||= `git config --get remote.#{git_remote}.url`
    end

    private

    def github_site
      options[:github_site] || "https://github.com"
    end

    def git_remote
      options[:git_remote]
    end
  end
end
