# frozen_string_literal: true

require_relative "helper"
require_relative "argv_parser"
require_relative "parser_file"
require_relative "file_parser_chooser"
require_relative "git_remote"

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

        fill_missing_user_and_project_from_remote!(options)
        abort_if_user_and_project_not_given!(options)

        options.print_options

        options
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

      private

      def abort_if_user_and_project_not_given!(options)
        return if options[:user] && options[:project]

        warn "Configure which user and project to work on."
        warn "Use --user and --project, set them in the config file, or run inside a git checkout with a configured remote."
        warn ArgvParser.banner

        Kernel.abort
      end

      def fill_missing_user_and_project_from_remote!(options)
        return if options[:user] && options[:project]

        remote_options = GitRemote.user_and_project
        return unless remote_options

        options[:user] ||= remote_options[:user]
        options[:project] ||= remote_options[:project]
      end
    end
  end
end
