#!/usr/bin/env ruby
# frozen_string_literal: true
require "optparse"
require "pp"
require_relative "version"
require_relative "helper"
module GitHubChangelogGenerator
  class Parser
    # parse options with optparse
    def self.parse_options
      options = default_options

      ParserFile.new(options).parse!

      parser = setup_parser(options)
      parser.parse!

      fetch_user_and_project(options)

      abort(parser.banner) unless options[:user] && options[:project]

      print_options(options)

      options
    end

    # If options set to verbose, print the parsed options.
    #
    # The GitHub `:token` key is censored in the output.
    #
    # @param options [Hash] The options to display
    # @option options [Boolean] :verbose If false this method does nothing
    def self.print_options(options)
      if options[:verbose]
        Helper.log.info "Performing task with options:"
        options_to_display = options.clone
        options_to_display[:token] = options_to_display[:token].nil? ? nil : "hidden value"
        pp options_to_display
        puts ""
      end
    end

    # setup parsing options
    def self.setup_parser(options)
      parser = OptionParser.new do |opts| # rubocop:disable Metrics/BlockLength
        opts.banner = "Usage: github_changelog_generator [options]"
        opts.on("-u", "--user [USER]", "Username of the owner of target GitHub repo") do |last|
          options[:user] = last
        end
        opts.on("-p", "--project [PROJECT]", "Name of project on GitHub") do |last|
          options[:project] = last
        end
        opts.on("-t", "--token [TOKEN]", "To make more than 50 requests per hour your GitHub token is required. You can generate it at: https://github.com/settings/tokens/new") do |last|
          options[:token] = last
        end
        opts.on("-f", "--date-format [FORMAT]", "Date format. Default is %Y-%m-%d") do |last|
          options[:date_format] = last
        end
        opts.on("-o", "--output [NAME]", "Output file. Default is CHANGELOG.md") do |last|
          options[:output] = last
        end
        opts.on("-b", "--base [NAME]", "Optional base file to append generated changes to.") do |last|
          options[:base] = last
        end
        opts.on("--bugs-label [LABEL]", "Setup custom label for bug-fixes section. Default is \"**Fixed bugs:**\"") do |v|
          options[:bug_prefix] = v
        end
        opts.on("--enhancement-label [LABEL]", "Setup custom label for enhancements section. Default is \"**Implemented enhancements:**\"") do |v|
          options[:enhancement_prefix] = v
        end
        opts.on("--issues-label [LABEL]", "Setup custom label for closed-issues section. Default is \"**Closed issues:**\"") do |v|
          options[:issue_prefix] = v
        end
        opts.on("--header-label [LABEL]", "Setup custom header label. Default is \"# Change Log\"") do |v|
          options[:header] = v
        end
        opts.on("--front-matter [JSON]", "Add YAML front matter. Formatted as JSON because it's easier to add on the command line") do |v|
          options[:frontmatter] = JSON.parse(v).to_yaml + "---\n"
        end
        opts.on("--pr-label [LABEL]", "Setup custom label for pull requests section. Default is \"**Merged pull requests:**\"") do |v|
          options[:merge_prefix] = v
        end
        opts.on("--[no-]issues", "Include closed issues in changelog. Default is true") do |v|
          options[:issues] = v
        end
        opts.on("--[no-]issues-wo-labels", "Include closed issues without labels in changelog. Default is true") do |v|
          options[:add_issues_wo_labels] = v
        end
        opts.on("--[no-]pr-wo-labels", "Include pull requests without labels in changelog. Default is true") do |v|
          options[:add_pr_wo_labels] = v
        end
        opts.on("--[no-]pull-requests", "Include pull-requests in changelog. Default is true") do |v|
          options[:pulls] = v
        end
        opts.on("--[no-]filter-by-milestone", "Use milestone to detect when issue was resolved. Default is true") do |last|
          options[:filter_issues_by_milestone] = last
        end
        opts.on("--[no-]author", "Add author of pull-request in the end. Default is true") do |author|
          options[:author] = author
        end
        opts.on("--usernames-as-github-logins", "Use GitHub tags instead of Markdown links for the author of an issue or pull-request.") do |v|
          options[:usernames_as_github_logins] = v
        end
        opts.on("--unreleased-only", "Generate log from unreleased closed issues only.") do |v|
          options[:unreleased_only] = v
        end
        opts.on("--[no-]unreleased", "Add to log unreleased closed issues. Default is true") do |v|
          options[:unreleased] = v
        end
        opts.on("--unreleased-label [label]", "Setup custom label for unreleased closed issues section. Default is \"**Unreleased:**\"") do |v|
          options[:unreleased_label] = v
        end
        opts.on("--[no-]compare-link", "Include compare link (Full Changelog) between older version and newer version. Default is true") do |v|
          options[:compare_link] = v
        end
        opts.on("--include-labels  x,y,z", Array, "Only issues with the specified labels will be included in the changelog.") do |list|
          options[:include_labels] = list
        end
        opts.on("--exclude-labels  x,y,z", Array, 'Issues with the specified labels will be always excluded from changelog. Default is \'duplicate,question,invalid,wontfix\'') do |list|
          options[:exclude_labels] = list
        end
        opts.on("--bug-labels  x,y,z", Array, 'Issues with the specified labels will be always added to "Fixed bugs" section. Default is \'bug,Bug\'') do |list|
          options[:bug_labels] = list
        end
        opts.on("--enhancement-labels  x,y,z", Array, 'Issues with the specified labels will be always added to "Implemented enhancements" section. Default is \'enhancement,Enhancement\'') do |list|
          options[:enhancement_labels] = list
        end
        opts.on("--issue-line-labels x,y,z", Array, 'The specified labels will be shown in brackets next to each matching issue. Use "ALL" to show all labels. Default is [].') do |list|
          options[:issue_line_labels] = list
        end
        opts.on("--between-tags  x,y,z", Array, "Change log will be filled only between specified tags") do |list|
          options[:between_tags] = list
        end
        opts.on("--exclude-tags  x,y,z", Array, "Change log will exclude specified tags") do |list|
          options[:exclude_tags] = list
        end
        opts.on("--exclude-tags-regex [REGEX]", "Apply a regular expression on tag names so that they can be excluded, for example: --exclude-tags-regex \".*\+\d{1,}\" ") do |last|
          options[:exclude_tags_regex] = last
        end
        opts.on("--since-tag  x", "Change log will start after specified tag") do |v|
          options[:since_tag] = v
        end
        opts.on("--due-tag  x", "Change log will end before specified tag") do |v|
          options[:due_tag] = v
        end
        opts.on("--max-issues [NUMBER]", Integer, "Max number of issues to fetch from GitHub. Default is unlimited") do |max|
          options[:max_issues] = max
        end
        opts.on("--release-url [URL]", "The URL to point to for release links, in printf format (with the tag as variable).") do |url|
          options[:release_url] = url
        end
        opts.on("--github-site [URL]", "The Enterprise Github site on which your project is hosted.") do |last|
          options[:github_site] = last
        end
        opts.on("--github-api [URL]", "The enterprise endpoint to use for your Github API.") do |last|
          options[:github_endpoint] = last
        end
        opts.on("--simple-list", "Create simple list from issues and pull requests. Default is false.") do |v|
          options[:simple_list] = v
        end
        opts.on("--future-release [RELEASE-VERSION]", "Put the unreleased changes in the specified release number.") do |future_release|
          options[:future_release] = future_release
        end
        opts.on("--release-branch [RELEASE-BRANCH]", "Limit pull requests to the release branch, such as master or release") do |release_branch|
          options[:release_branch] = release_branch
        end
        opts.on("--[no-]http-cache", "Use HTTP Cache to cache Github API requests (useful for large repos) Default is true.") do |http_cache|
          options[:http_cache] = http_cache
        end
        opts.on("--cache-file [CACHE-FILE]", "Filename to use for cache. Default is /tmp/github-changelog-http-cache") do |cache_file|
          options[:cache_file] = cache_file
        end
        opts.on("--cache-log [CACHE-LOG]", "Filename to use for cache log. Default is /tmp/github-changelog-logger.log") do |cache_log|
          options[:cache_log] = cache_log
        end
        opts.on("--[no-]verbose", "Run verbosely. Default is true") do |v|
          options[:verbose] = v
        end
        opts.on("-v", "--version", "Print version number") do |_v|
          puts "Version: #{GitHubChangelogGenerator::VERSION}"
          exit
        end
        opts.on("-h", "--help", "Displays Help") do
          puts opts
          exit
        end
      end
      parser
    end

    # @return [Hash] Default options
    def self.default_options
      Options.new(
        tag1: nil,
        tag2: nil,
        date_format: "%Y-%m-%d",
        output: "CHANGELOG.md",
        base: "HISTORY.md",
        issues: true,
        add_issues_wo_labels: true,
        add_pr_wo_labels: true,
        pulls: true,
        filter_issues_by_milestone: true,
        author: true,
        unreleased: true,
        unreleased_label: "Unreleased",
        compare_link: true,
        enhancement_labels: ["enhancement", "Enhancement", "Type: Enhancement"],
        bug_labels: ["bug", "Bug", "Type: Bug"],
        exclude_labels: ["duplicate", "question", "invalid", "wontfix", "Duplicate", "Question", "Invalid", "Wontfix", "Meta: Exclude From Changelog"],
        issue_line_labels: [],
        max_issues: nil,
        simple_list: false,
        verbose: true,
        header: "# Change Log",
        merge_prefix: "**Merged pull requests:**",
        issue_prefix: "**Closed issues:**",
        bug_prefix: "**Fixed bugs:**",
        enhancement_prefix: "**Implemented enhancements:**",
        git_remote: "origin",
        http_cache: true,
        cache_file: "/tmp/github-changelog-http-cache",
        cache_log: "/tmp/github-changelog-logger.log"
      )
    end

    # If `:user` or `:project` not set in options, try setting them
    # Valid unnamed parameters:
    # 1) in 1 param: repo_name/project
    # 2) in 2 params: repo name project
    def self.fetch_user_and_project(options)
      if options[:user].nil? || options[:project].nil?
        user, project = user_and_project_from_git(options, ARGV[0], ARGV[1])
        options[:user] ||= user
        options[:project] ||= project
      end
    end

    # Sets `:user` and `:project` in `options` from CLI arguments or `git remote`
    # @param [String] arg0 first argument in cli
    # @param [String] arg1 second argument in cli
    # @return [Array<String>] user and project, or nil if unsuccessful
    def self.user_and_project_from_git(options, arg0 = nil, arg1 = nil)
      user, project = user_project_from_option(arg0, arg1, options[:github_site])
      unless user && project
        if ENV["RUBYLIB"] =~ /ruby-debug-ide/
          user = "skywinder"
          project = "changelog_test"
        else
          remote = `git config --get remote.#{options[:git_remote]}.url`
          user, project = user_project_from_remote(remote)
        end
      end

      [user, project]
    end

    # Returns GitHub username and project from CLI arguments
    #
    # @param arg0 [String] This parameter takes two forms: Either a full
    #                      GitHub URL, or a 'username/projectname', or
    #                      simply a GitHub username
    # @param arg1 [String] If arg0 is given as a username,
    #                      then arg1 can given as a projectname
    # @param github_site [String] Domain name of GitHub site
    #
    # @return [Array, nil] user and project, or nil if unsuccessful
    def self.user_project_from_option(arg0, arg1, github_site)
      user = nil
      project = nil
      github_site ||= "github.com"
      if arg0 && !arg1
        # this match should parse  strings such "https://github.com/skywinder/Github-Changelog-Generator" or
        # "skywinder/Github-Changelog-Generator" to user and name
        match = /(?:.+#{Regexp.escape(github_site)}\/)?(.+)\/(.+)/.match(arg0)

        begin
          param = match[2].nil?
        rescue
          puts "Can't detect user and name from first parameter: '#{arg0}' -> exit'"
          return
        end
        if param
          return
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
    # @param git_remote_output [String] Output of git remote command
    #
    # @return [Array] user and project
    def self.user_project_from_remote(git_remote_output)
      user = nil
      project = nil
      GIT_REMOTE_PATTERNS.each do |git_remote_pattern|
        git_remote_pattern =~ git_remote_output

        if Regexp.last_match
          user = Regexp.last_match(:user)
          project = Regexp.last_match(:project)
          break
        end
      end

      [user, project]
    end
  end
end
