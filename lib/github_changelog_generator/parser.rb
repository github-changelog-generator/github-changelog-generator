#!/usr/bin/env ruby
require "optparse"
require "pp"
require_relative "version"

module GitHubChangelogGenerator
  class Parser
    def self.parse_options
      options = {
        tag1: nil,
        tag2: nil,
        dateformat: "%Y-%m-%d",
        output: "CHANGELOG.md",
        issues: true,
        add_issues_wo_labels: true,
        add_pr_wo_labels: true,
        pulls: true,
        filter_issues_by_milestone: true,
        author: true,
        unreleased: true,
        unreleased_label: "Unreleased",
        compare_link: true,
        include_labels: %w(bug enhancement),
        exclude_labels: %w(duplicate question invalid wontfix),
        max_issues: nil,
        simple_list: false,
        verbose: true,

        merge_prefix: "**Merged pull requests:**",
        issue_prefix: "**Closed issues:**",
        bug_prefix: "**Fixed bugs:**",
        enhancement_prefix: "**Implemented enhancements:**",
        branch: "origin"
      }

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
          options[:dateformat] = last
        end
        opts.on("-o", "--output [NAME]", "Output file. Default is CHANGELOG.md") do |last|
          options[:output] = last
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
        opts.on("--include-labels  x,y,z", Array, 'Only issues with the specified labels will be included in the changelog. Default is \'bug,enhancement\'') do |list|
          options[:include_labels] = list
        end
        opts.on("--exclude-labels  x,y,z", Array, 'Issues with the specified labels will be always excluded from changelog. Default is \'duplicate,question,invalid,wontfix\'') do |list|
          options[:exclude_labels] = list
        end
        opts.on("--max-issues [NUMBER]", Integer, "Max number of issues to fetch from GitHub. Default is unlimited") do |max|
          options[:max_issues] = max
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

      parser.parse!

      if ARGV[0] && !ARGV[1]
        github_site = options[:github_site] ? options[:github_site] : "github.com"
        # this match should parse  strings such "https://github.com/skywinder/Github-Changelog-Generator" or "skywinder/Github-Changelog-Generator" to user and name
        match = /(?:.+#{Regexp.escape(github_site)}\/)?(.+)\/(.+)/.match(ARGV[0])

        begin
          param = match[2].nil?
        rescue
          puts "Can't detect user and name from first parameter: '#{ARGV[0]}' -> exit'"
          exit
        end
        if param
          exit
        else
          options[:user] = match[1]
          options[:project] = match[2]
        end

      end

      if !options[:user] && !options[:project]
        remote = `git config --get remote.#{options[:branch]}.url`
        # try to find repo in format:
        # origin	git@github.com:skywinder/Github-Changelog-Generator.git (fetch)
        # git@github.com:skywinder/Github-Changelog-Generator.git
        match = /.*(?:[:\/])((?:-|\w|\.)*)\/((?:-|\w|\.)*)(?:\.git).*/.match(remote)

        if match && match[1] && match[2]
          puts "Detected user:#{match[1]}, project:#{match[2]}"
          options[:user], options[:project] = match[1], match[2]
        else
          # try to find repo in format:
          # origin	https://github.com/skywinder/ChangelogMerger (fetch)
          # https://github.com/skywinder/ChangelogMerger
          match = /.*\/((?:-|\w|\.)*)\/((?:-|\w|\.)*).*/.match(remote)
          if match && match[1] && match[2]
            puts "Detected user:#{match[1]}, project:#{match[2]}"
            options[:user], options[:project] = match[1], match[2]
          end
        end
      end

      if !options[:user] || !options[:project]
        puts parser.banner
        exit
      end

      if ARGV[1]
        options[:tag1] = ARGV[0]
        options[:tag2] = ARGV[1]
      end

      if options[:verbose]
        puts "Performing task with options:"
        pp options
        puts ""
      end

      options
    end
  end
end
