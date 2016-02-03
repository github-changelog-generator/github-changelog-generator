#!/usr/bin/env ruby
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

      user_and_project_from_git(options)

      abort(parser.banner) unless options[:user] && options[:project]

      print_options(options)

      options
    end

    # @param [Hash] options to display
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
      parser = OptionParser.new do |opts|
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
        opts.on("--bugs-label [LABEL]", "Setup custom label for bug-fixes section. Default is \"**Fixed bugs:**""") do |v|
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
        opts.on("--unreleased-only", "Generate log from unreleased closed issues only.") do |v|
          options[:unreleased_only] = v
        end
        opts.on("--[no-]unreleased", "Add to log unreleased closed issues. Default is true") do |v|
          options[:unreleased] = v
        end
        opts.on("--unreleased-label [label]", "Add to log unreleased closed issues. Default is true") do |v|
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
        opts.on("--between-tags  x,y,z", Array, "Change log will be filled only between specified tags") do |list|
          options[:between_tags] = list
        end
        opts.on("--exclude-tags  x,y,z", Array, "Change log will exclude specified tags") do |list|
          options[:exclude_tags] = list
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

    # just get default options
    def self.default_options
      {
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
        enhancement_labels: %w(enhancement Enhancement),
        bug_labels: %w(bug Bug),
        exclude_labels: %w(duplicate question invalid wontfix Duplicate Question Invalid Wontfix),
        max_issues: nil,
        simple_list: false,
        verbose: true,
        header: "# Change Log",
        merge_prefix: "**Merged pull requests:**",
        issue_prefix: "**Closed issues:**",
        bug_prefix: "**Fixed bugs:**",
        enhancement_prefix: "**Implemented enhancements:**",
        git_remote: "origin"
      }
    end

    def self.user_and_project_from_git(options)
      if options[:user].nil? || options[:project].nil?
        detect_user_and_project(options, ARGV[0], ARGV[1])
      end
    end

    # Detects user and project from git
    def self.detect_user_and_project(options, arg0 = nil, arg1 = nil)
      options[:user], options[:project] = user_project_from_option(arg0, arg1, options[:github_site])
      return if options[:user] && options[:project]

      if ENV["RUBYLIB"] =~ /ruby-debug-ide/
        options[:user] = "skywinder"
        options[:project] = "changelog_test"
      else
        remote = `git config --get remote.#{options[:git_remote]}.url`
        options[:user], options[:project] = user_project_from_remote(remote)
      end
    end

    # Try to find user and project name from git remote output
    #
    # @param [String] output of git remote command
    # @return [Array] user and project
    def self.user_project_from_option(arg0, arg1, github_site)
      user = nil
      project = nil
      github_site ||= "github.com"
      if arg0 && !arg1
        # this match should parse  strings such "https://github.com/skywinder/Github-Changelog-Generator" or "skywinder/Github-Changelog-Generator" to user and name
        puts arg0
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

    # Try to find user and project name from git remote output
    #
    # @param [String] output of git remote command
    # @return [Array] user and project
    def self.user_project_from_remote(remote)
      # try to find repo in format:
      # origin	git@github.com:skywinder/Github-Changelog-Generator.git (fetch)
      # git@github.com:skywinder/Github-Changelog-Generator.git
      regex1 = /.*(?:[:\/])((?:-|\w|\.)*)\/((?:-|\w|\.)*)(?:\.git).*/

      # try to find repo in format:
      # origin	https://github.com/skywinder/ChangelogMerger (fetch)
      # https://github.com/skywinder/ChangelogMerger
      regex2 = /.*\/((?:-|\w|\.)*)\/((?:-|\w|\.)*).*/

      remote_structures = [regex1, regex2]

      user = nil
      project = nil
      remote_structures.each do |regex|
        matches = Regexp.new(regex).match(remote)

        if matches && matches[1] && matches[2]
          puts "Detected user:#{matches[1]}, project:#{matches[2]}"
          user = matches[1]
          project = matches[2]
        end

        break unless matches.nil?
      end

      [user, project]
    end
  end
end
