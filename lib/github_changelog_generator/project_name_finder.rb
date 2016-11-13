# frozen_string_literal: true
module GitHubChangelogGenerator
  class ProjectNameFinder
    attr_reader :options, :args

    # @param options [Options]
    # @param args [Array] ARGV or the empty list
    # @option args [String] 0 This parameter takes two forms: Either a full
    #                         GitHub URL, or a 'username/projectname', or
    #                         simply a GitHub username
    # @option args [String] 1 If args[0] is given as a username,
    #                         then args[1] can given as a projectname
    def initialize(options, args)
      @options = options
      @args = args
    end

    FIXED_TEST_PROJECT = %w(skywinder changelog_test)

    # Returns a tuple of user and project from CLI arguments or git remote.
    #
    # @return [Array<String>] user and project, or nil if unsuccessful
    def call
      [
        -> { from_cli_option },
        -> { FIXED_TEST_PROJECT if in_development? },
        -> { from_git_remote }
      ].find(-> { proc { [nil, nil] } }) do |strategy|
        user, project = strategy.call
        user && project
      end.call
    end

    def in_development?
      ENV["RUBYLIB"] =~ /ruby-debug-ide/
    end

    # Returns GitHub username and project from CLI arguments
    #
    # @return [Array, nil] user and project, or nil if unsuccessful
    def from_cli_option
      user = nil
      project = nil
      if args[0] && !args[1]
        # this match should parse  strings such "https://github.com/skywinder/Github-Changelog-Generator" or
        # "skywinder/Github-Changelog-Generator" to user and name
        match = /(?:.+#{Regexp.escape(github_site)}\/)?(.+)\/(.+)/.match(args[0])

        begin
          param = match[2].nil?
        rescue
          puts "Can't detect user and name from first parameter: '#{args[0]}' -> exit'"
          return
        end
        if param
          return [nil, nil]
        else
          user = match[1]
          project = match[2]
        end
      end
      [user, project]
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
      user = nil
      project = nil
      GIT_REMOTE_PATTERNS.each do |git_remote_pattern|
        git_remote_pattern =~ git_remote_content

        if Regexp.last_match
          user = Regexp.last_match(:user)
          project = Regexp.last_match(:project)
          break
        end
      end

      [user, project]
    end

    # @return [String] Output of git remote command
    def git_remote_content
      @git_remote_content ||= `git config --get remote.#{git_remote}.url`
    end

    private

    def github_site
      options[:github_site] || "github.com"
    end

    def git_remote
      options[:git_remote]
    end
  end
end
