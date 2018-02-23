#!/usr/bin/env ruby
# frozen_string_literal: true

require "optparse"
require "pp"
require "github_changelog_generator/version"
require "github_changelog_generator/helper"

module GitHubChangelogGenerator
  class Parser
    # parse options with optparse
    def self.parse_options
      options = default_options

      ParserFile.new(options).parse!

      parser = setup_parser(options)
      begin parser.parse!
      rescue OptionParser::InvalidOption => e
        abort [e, parser].join("\n")
      end

      unless options[:user] && options[:project]
        warn "Configure which user and project to work on."
        warn "Options --user and --project, or settings to that effect. See --help for more."
        abort(parser.banner)
      end

      options.print_options

      options
    end

    # Setup parsing options
    #
    # @param options [Options]
    # @return [OptionParser]
    def self.setup_parser(options)
      OptionParser.new do |opts| # rubocop:disable Metrics/BlockLength
        opts.banner = "Usage: github_changelog_generator --user USER --project PROJECT [options]"
        opts.on("-u", "--user USER", "Username of the owner of target GitHub repo") do |last|
          options[:user] = last
        end
        opts.on("-p", "--project PROJECT", "Name of project on GitHub") do |last|
          options[:project] = last
        end
        opts.on("-t", "--token [TOKEN]", "To make more than 50 requests per hour your GitHub token is required. You can generate it at: https://github.com/settings/tokens/new") do |last|
          options[:token] = last
        end
        opts.on("-f", "--date-format FORMAT", "Date format. Default is %Y-%m-%d") do |last|
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
        opts.on("--breaking-label [LABEL]", "Setup custom label for the breaking changes section. Default is \"**Breaking changes:**\"") do |v|
          options[:breaking_prefix] = v
        end
        opts.on("--issues-label [LABEL]", "Setup custom label for closed-issues section. Default is \"**Closed issues:**\"") do |v|
          options[:issue_prefix] = v
        end
        opts.on("--header-label [LABEL]", "Setup custom header label. Default is \"# Changelog\"") do |v|
          options[:header] = v
        end
        opts.on("--configure-sections [Hash, String]", "Define your own set of sections which overrides all default sections") do |v|
          options[:configure_sections] = v
        end
        opts.on("--add-sections [Hash, String]", "Add new sections but keep the default sections") do |v|
          options[:add_sections] = v
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
        opts.on("--include-labels  x,y,z", Array, "Of the labeled issues, only include the ones with the given labels.") do |list|
          options[:include_labels] = list
        end
        opts.on("--exclude-labels  x,y,z", Array, "Issues with the specified labels will be excluded from changelog. Default is 'duplicate,question,invalid,wontfix'") do |list|
          options[:exclude_labels] = list
        end
        opts.on("--bug-labels  x,y,z", Array, 'Issues with the specified labels will be always added to "Fixed bugs" section. Default is \'bug,Bug\'') do |list|
          options[:bug_labels] = list
        end
        opts.on("--enhancement-labels  x,y,z", Array, 'Issues with the specified labels will be always added to "Implemented enhancements" section. Default is \'enhancement,Enhancement\'') do |list|
          options[:enhancement_labels] = list
        end
        opts.on("--breaking-labels x,y,z", Array, 'Issues with these labels will be added to a new section, called "Breaking Changes". Default is \'backwards-incompatible\'') do |list|
          options[:breaking_labels] = list
        end
        opts.on("--issue-line-labels x,y,z", Array, 'The specified labels will be shown in brackets next to each matching issue. Use "ALL" to show all labels. Default is [].') do |list|
          options[:issue_line_labels] = list
        end
        opts.on("--exclude-tags  x,y,z", Array, "Changelog will exclude specified tags") do |list|
          options[:exclude_tags] = list
        end
        opts.on("--exclude-tags-regex [REGEX]", "Apply a regular expression on tag names so that they can be excluded, for example: --exclude-tags-regex \".*\+\d{1,}\" ") do |last|
          options[:exclude_tags_regex] = last
        end
        opts.on("--since-tag  x", "Changelog will start after specified tag") do |v|
          options[:since_tag] = v
        end
        opts.on("--due-tag  x", "Changelog will end before specified tag") do |v|
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
        opts.on("--cache-file [CACHE-FILE]", "Filename to use for cache. Default is github-changelog-http-cache in a temporary directory.") do |cache_file|
          options[:cache_file] = cache_file
        end
        opts.on("--cache-log [CACHE-LOG]", "Filename to use for cache log. Default is github-changelog-logger.log in a temporary directory.") do |cache_log|
          options[:cache_log] = cache_log
        end
        opts.on("--ssl-ca-file [PATH]", "Path to cacert.pem file. Default is a bundled lib/github_changelog_generator/ssl_certs/cacert.pem. Respects SSL_CA_PATH.") do |ssl_ca_file|
          options[:ssl_ca_file] = ssl_ca_file
        end
        opts.on("--require x,y,z", Array, "Path to Ruby file(s) to require.") do |paths|
          options[:require] = paths
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
    end

    # @return [Options] Default options
    def self.default_options
      Options.new(
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
        breaking_labels: %w[backwards-incompatible breaking],
        configure_sections: {},
        add_sections: {},
        issue_line_labels: [],
        max_issues: nil,
        simple_list: false,
        ssl_ca_file: nil,
        verbose: true,
        header: "# Changelog",
        merge_prefix: "**Merged pull requests:**",
        issue_prefix: "**Closed issues:**",
        bug_prefix: "**Fixed bugs:**",
        enhancement_prefix: "**Implemented enhancements:**",
        breaking_prefix: "**Breaking changes:**",
        http_cache: true,
        require: []
      )
    end
  end
end
