#!/usr/bin/env ruby
# frozen_string_literal: true

require "github_changelog_generator/helper"
require "github_changelog_generator/argv_parser"
require "github_changelog_generator/parser_file"

module GitHubChangelogGenerator
  class Parser
    class << self
      PARSERS = [
        ArgvParser, # Parse arguments first to get initial options populated
        FileParserChooser, # Then parse possible configuration files
        ArgvParser # Lastly parse arguments again to keep the given arguments the strongest
      ].freeze

      def parse_options(argv = ARGV)
        options = default_options

        PARSERS.each do |parser|
          parser.new(options).parse!(argv)
        end

        abort_if_user_and_project_not_given!(options)

        options.print_options

        options
      end

      def abort_if_user_and_project_not_given!(options)
        return if options[:user] && options[:project]

        warn "Configure which user and project to work on."
        warn "Options --user and --project, or settings to that effect. See --help for more."
        warn ArgvParser.banner

        Kernel.abort
      end

      # @return [Options] Default options
      def default_options
        Options.new(
          date_format: "%Y-%m-%d",
          output: "CHANGELOG.md",
          base: "HISTORY.md",
          issues: true,
          add_issues_wo_labels: true,
          add_pr_wo_labels: true,
          pulls: true,
          filter_issues_by_milestone: true,
          issues_of_open_milestones: true,
          author: true,
          unreleased: true,
          unreleased_label: "Unreleased",
          compare_link: true,
          exclude_labels: ["duplicate", "question", "invalid", "wontfix", "Duplicate", "Question", "Invalid", "Wontfix", "Meta: Exclude From Changelog"],
          summary_labels: ["Release summary", "release-summary", "Summary", "summary"],
          breaking_labels: ["backwards-incompatible", "Backwards incompatible", "breaking"],
          enhancement_labels: ["enhancement", "Enhancement", "Type: Enhancement"],
          bug_labels: ["bug", "Bug", "Type: Bug"],
          deprecated_labels: ["deprecated", "Deprecated", "Type: Deprecated"],
          removed_labels: ["removed", "Removed", "Type: Removed"],
          security_labels: ["security", "Security", "Type: Security"],
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
          summary_prefix: "",
          breaking_prefix: "**Breaking changes:**",
          enhancement_prefix: "**Implemented enhancements:**",
          bug_prefix: "**Fixed bugs:**",
          deprecated_prefix: "**Deprecated:**",
          removed_prefix: "**Removed:**",
          security_prefix: "**Security fixes:**",
          http_cache: true,
          require: [],
          config_file: ".github_changelog_generator"
        )
      end
    end
  end
end
