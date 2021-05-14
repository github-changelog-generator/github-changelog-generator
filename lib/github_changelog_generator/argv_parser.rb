# frozen_string_literal: true

require "optparse"
require "github_changelog_generator/version"

module GitHubChangelogGenerator
  class ArgvParser
    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def parse!(argv)
      parser.parse(argv)
    rescue OptionParser::ParseError => e
      warn [e, parser].join("\n")
      Kernel.abort
    end

    def parser
      @parser ||= OptionParser.new do |opts| # rubocop:disable Metrics/BlockLength
        opts.banner = "Usage: github_changelog_generator --user USER --project PROJECT [options]"
        opts.on("-u", "--user USER", "Username of the owner of the target GitHub repo OR the namespace of target Github repo if owned by an organization.") do |last|
          options[:user] = last
        end
        opts.on("-p", "--project PROJECT", "Name of project on GitHub.") do |last|
          options[:project] = last
        end
        opts.on("-t", "--token TOKEN", "To make more than 50 requests per hour your GitHub token is required. You can generate it at: https://github.com/settings/tokens/new") do |last|
          options[:token] = last
        end
        opts.on("-f", "--date-format FORMAT", "Date format. Default is %Y-%m-%d.") do |last|
          options[:date_format] = last
        end
        opts.on("-o", "--output NAME", "Output file. To print to STDOUT instead, use blank as path. Default is CHANGELOG.md") do |last|
          options[:output] = last
        end
        opts.on("-b", "--base NAME", "Optional base file to append generated changes to. Default is HISTORY.md") do |last|
          options[:base] = last
        end
        opts.on("--summary-label LABEL", "Set up custom label for the release summary section. Default is \"\".") do |v|
          options[:summary_prefix] = v
        end
        opts.on("--breaking-label LABEL", "Set up custom label for the breaking changes section. Default is \"**Breaking changes:**\".") do |v|
          options[:breaking_prefix] = v
        end
        opts.on("--enhancement-label LABEL", "Set up custom label for enhancements section. Default is \"**Implemented enhancements:**\".") do |v|
          options[:enhancement_prefix] = v
        end
        opts.on("--bugs-label LABEL", "Set up custom label for bug-fixes section. Default is \"**Fixed bugs:**\".") do |v|
          options[:bug_prefix] = v
        end
        opts.on("--deprecated-label LABEL", "Set up custom label for the deprecated changes section. Default is \"**Deprecated:**\".") do |v|
          options[:deprecated_prefix] = v
        end
        opts.on("--removed-label LABEL", "Set up custom label for the removed changes section. Default is \"**Removed:**\".") do |v|
          options[:removed_prefix] = v
        end
        opts.on("--security-label LABEL", "Set up custom label for the security changes section. Default is \"**Security fixes:**\".") do |v|
          options[:security_prefix] = v
        end
        opts.on("--issues-label LABEL", "Set up custom label for closed-issues section. Default is \"**Closed issues:**\".") do |v|
          options[:issue_prefix] = v
        end
        opts.on("--header-label LABEL", "Set up custom header label. Default is \"# Changelog\".") do |v|
          options[:header] = v
        end
        opts.on("--configure-sections HASH, STRING", "Define your own set of sections which overrides all default sections.") do |v|
          options[:configure_sections] = v
        end
        opts.on("--add-sections HASH, STRING", "Add new sections but keep the default sections.") do |v|
          options[:add_sections] = v
        end
        opts.on("--front-matter JSON", "Add YAML front matter. Formatted as JSON because it's easier to add on the command line.") do |v|
          require "yaml"
          options[:frontmatter] = "#{JSON.parse(v).to_yaml}---\n"
        end
        opts.on("--pr-label LABEL", "Set up custom label for pull requests section. Default is \"**Merged pull requests:**\".") do |v|
          options[:merge_prefix] = v
        end
        opts.on("--[no-]issues", "Include closed issues in changelog. Default is true.") do |v|
          options[:issues] = v
        end
        opts.on("--[no-]issues-wo-labels", "Include closed issues without labels in changelog. Default is true.") do |v|
          options[:add_issues_wo_labels] = v
        end
        opts.on("--[no-]pr-wo-labels", "Include pull requests without labels in changelog. Default is true.") do |v|
          options[:add_pr_wo_labels] = v
        end
        opts.on("--[no-]pull-requests", "Include pull-requests in changelog. Default is true.") do |v|
          options[:pulls] = v
        end
        opts.on("--[no-]filter-by-milestone", "Use milestone to detect when issue was resolved. Default is true.") do |last|
          options[:filter_issues_by_milestone] = last
        end
        opts.on("--[no-]issues-of-open-milestones", "Include issues of open milestones. Default is true.") do |v|
          options[:issues_of_open_milestones] = v
        end
        opts.on("--[no-]author", "Add author of pull request at the end. Default is true.") do |author|
          options[:author] = author
        end
        opts.on("--usernames-as-github-logins", "Use GitHub tags instead of Markdown links for the author of an issue or pull-request.") do |v|
          options[:usernames_as_github_logins] = v
        end
        opts.on("--unreleased-only", "Generate log from unreleased closed issues only.") do |v|
          options[:unreleased_only] = v
        end
        opts.on("--[no-]unreleased", "Add to log unreleased closed issues. Default is true.") do |v|
          options[:unreleased] = v
        end
        opts.on("--unreleased-label LABEL", "Set up custom label for unreleased closed issues section. Default is \"**Unreleased:**\".") do |v|
          options[:unreleased_label] = v
        end
        opts.on("--[no-]compare-link", "Include compare link (Full Changelog) between older version and newer version. Default is true.") do |v|
          options[:compare_link] = v
        end
        opts.on("--include-labels  x,y,z", Array, "Of the labeled issues, only include the ones with the specified labels.") do |list|
          options[:include_labels] = list
        end
        opts.on("--exclude-labels  x,y,z", Array, "Issues with the specified labels will be excluded from changelog. Default is 'duplicate,question,invalid,wontfix'.") do |list|
          options[:exclude_labels] = list
        end
        opts.on("--summary-labels x,y,z", Array, 'Issues with these labels will be added to a new section, called "Release Summary". The section display only body of issues. Default is \'release-summary,summary\'.') do |list|
          options[:summary_labels] = list
        end
        opts.on("--breaking-labels x,y,z", Array, 'Issues with these labels will be added to a new section, called "Breaking changes". Default is \'backwards-incompatible,breaking\'.') do |list|
          options[:breaking_labels] = list
        end
        opts.on("--enhancement-labels  x,y,z", Array, 'Issues with the specified labels will be added to "Implemented enhancements" section. Default is \'enhancement,Enhancement\'.') do |list|
          options[:enhancement_labels] = list
        end
        opts.on("--bug-labels  x,y,z", Array, 'Issues with the specified labels will be added to "Fixed bugs" section. Default is \'bug,Bug\'.') do |list|
          options[:bug_labels] = list
        end
        opts.on("--deprecated-labels x,y,z", Array, 'Issues with the specified labels will be added to a section called "Deprecated". Default is \'deprecated,Deprecated\'.') do |list|
          options[:deprecated_labels] = list
        end
        opts.on("--removed-labels x,y,z", Array, 'Issues with the specified labels will be added to a section called "Removed". Default is \'removed,Removed\'.') do |list|
          options[:removed_labels] = list
        end
        opts.on("--security-labels x,y,z", Array, 'Issues with the specified labels will be added to a section called "Security fixes". Default is \'security,Security\'.') do |list|
          options[:security_labels] = list
        end
        opts.on("--issue-line-labels x,y,z", Array, 'The specified labels will be shown in brackets next to each matching issue. Use "ALL" to show all labels. Default is [].') do |list|
          options[:issue_line_labels] = list
        end
        opts.on("--include-tags-regex REGEX", "Apply a regular expression on tag names so that they can be included, for example: --include-tags-regex \".*\+\d{1,}\".") do |last|
          options[:include_tags_regex] = last
        end
        opts.on("--exclude-tags  x,y,z", Array, "Changelog will exclude specified tags") do |list|
          options[:exclude_tags] = list
        end
        opts.on("--exclude-tags-regex REGEX", "Apply a regular expression on tag names so that they can be excluded, for example: --exclude-tags-regex \".*\+\d{1,}\".") do |last|
          options[:exclude_tags_regex] = last
        end
        opts.on("--since-tag  x", "Changelog will start after specified tag.") do |v|
          options[:since_tag] = v
        end
        opts.on("--due-tag  x", "Changelog will end before specified tag.") do |v|
          options[:due_tag] = v
        end
        opts.on("--since-commit  x", "Fetch only commits after this time. eg. \"2017-01-01 10:00:00\"") do |v|
          options[:since_commit] = v
        end
        opts.on("--max-issues NUMBER", Integer, "Maximum number of issues to fetch from GitHub. Default is unlimited.") do |max|
          options[:max_issues] = max
        end
        opts.on("--release-url URL", "The URL to point to for release links, in printf format (with the tag as variable).") do |url|
          options[:release_url] = url
        end
        opts.on("--github-site URL", "The Enterprise GitHub site where your project is hosted.") do |last|
          options[:github_site] = last
        end
        opts.on("--github-api URL", "The enterprise endpoint to use for your GitHub API.") do |last|
          options[:github_endpoint] = last
        end
        opts.on("--simple-list", "Create a simple list from issues and pull requests. Default is false.") do |v|
          options[:simple_list] = v
        end
        opts.on("--future-release RELEASE-VERSION", "Put the unreleased changes in the specified release number.") do |future_release|
          options[:future_release] = future_release
        end
        opts.on("--release-branch RELEASE-BRANCH", "Limit pull requests to the release branch, such as master or release.") do |release_branch|
          options[:release_branch] = release_branch
        end
        opts.on("--[no-]http-cache", "Use HTTP Cache to cache GitHub API requests (useful for large repos). Default is true.") do |http_cache|
          options[:http_cache] = http_cache
        end
        opts.on("--cache-file CACHE-FILE", "Filename to use for cache. Default is github-changelog-http-cache in a temporary directory.") do |cache_file|
          options[:cache_file] = cache_file
        end
        opts.on("--cache-log CACHE-LOG", "Filename to use for cache log. Default is github-changelog-logger.log in a temporary directory.") do |cache_log|
          options[:cache_log] = cache_log
        end
        opts.on("--config-file CONFIG-FILE", "Path to configuration file. Default is .github_changelog_generator.") do |config_file|
          options[:config_file] = config_file
        end
        opts.on("--ssl-ca-file PATH", "Path to cacert.pem file. Default is a bundled lib/github_changelog_generator/ssl_certs/cacert.pem. Respects SSL_CA_PATH.") do |ssl_ca_file|
          options[:ssl_ca_file] = ssl_ca_file
        end
        opts.on("--require x,y,z", Array, "Path to Ruby file(s) to require before generating changelog.") do |paths|
          options[:require] = paths
        end
        opts.on("--[no-]verbose", "Run verbosely. Default is true.") do |v|
          options[:verbose] = v
        end
        opts.on("-v", "--version", "Print version number.") do |_v|
          puts "Version: #{GitHubChangelogGenerator::VERSION}"
          exit
        end
        opts.on("-h", "--help", "Displays Help.") do
          puts opts
          exit
        end
      end
    end

    class << self
      def banner
        new.parser.banner
      end
    end
  end
end
