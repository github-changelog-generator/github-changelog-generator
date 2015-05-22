require "github_changelog_generator/fetcher"
require_relative "generator_generation"
require_relative "generator_fetcher"
require_relative "generator_processor"

module GitHubChangelogGenerator
  # Default error for ChangelogGenerator
  class ChangelogGeneratorError < StandardError
  end

  class Generator
    attr_accessor :options, :all_tags, :github

    # A Generator responsible for all logic, related with change log generation from ready-to-parse issues
    #
    # Example:
    #   generator = GitHubChangelogGenerator::Generator.new
    #   content = generator.compound_changelog
    def initialize(options = nil)
      @options = options

      @fetcher = GitHubChangelogGenerator::Fetcher.new @options
      # @all_tags = get_filtered_tags
      @all_tags = @fetcher.get_all_tags

      # TODO: refactor this double asssign of @issues and @pull_requests and move all logic in one method
      @issues, @pull_requests = @fetcher.fetch_closed_issues_and_pr

      @pull_requests = @options[:pulls] ? get_filtered_pull_requests : []

      @issues = @options[:issues] ? get_filtered_issues : []

      fetch_event_for_issues_and_pr
      detect_actual_closed_dates
    end

    # Encapsulate characters to make markdown look as expected.
    #
    # @param [String] string
    # @return [String] encapsulated input string
    def encapsulate_string(string)
      string.gsub! '\\', '\\\\'

      encpas_chars = %w(> * _ \( \) [ ] #)
      encpas_chars.each do |char|
        string.gsub! char, "\\#{char}"
      end

      string
    end

    # Generates log for section with header and body
    #
    # @param [Array] pull_requests List or PR's in new section
    # @param [Array] issues List of issues in new section
    # @param [String] newer_tag Name of the newer tag. Could be nil for `Unreleased` section
    # @param [String] older_tag_name Older tag, used for the links. Could be nil for last tag.
    # @return [String] Ready and parsed section
    def create_log(pull_requests, issues, newer_tag, older_tag_name = nil)
      newer_tag_time = newer_tag.nil? ? Time.new : @fetcher.get_time_of_tag(newer_tag)
      if newer_tag.nil? && @options[:future_release]
        newer_tag_name = @options[:future_release]
        newer_tag_link = @options[:future_release]
      else
        newer_tag_name = newer_tag.nil? ? @options[:unreleased_label] : newer_tag["name"]
        newer_tag_link = newer_tag.nil? ? "HEAD" : newer_tag_name
      end

      github_site = options[:github_site] || "https://github.com"
      project_url = "#{github_site}/#{@options[:user]}/#{@options[:project]}"

      log = generate_header(newer_tag_name, newer_tag_link, newer_tag_time, older_tag_name, project_url)

      if @options[:issues]
        # Generate issues:
        bugs_a, enhancement_a, issues_a = parse_by_sections(issues)

        log += generate_sub_section(enhancement_a, @options[:enhancement_prefix])
        log += generate_sub_section(bugs_a, @options[:bug_prefix])
        log += generate_sub_section(issues_a, @options[:issue_prefix])
      end

      if @options[:pulls]
        # Generate pull requests:
        log += generate_sub_section(pull_requests, @options[:merge_prefix])
      end

      log
    end

    # This method sort issues by types
    # (bugs, features, or just closed issues) by labels
    #
    # @param [Array] issues
    # @return [Array] tuple of filtered arrays: (Bugs, Enhancements Issues)
    def parse_by_sections(issues)
      issues_a = []
      enhancement_a = []
      bugs_a = []

      issues.each do |dict|
        added = false
        dict.labels.each do |label|
          if label.name == "bug"
            bugs_a.push dict
            added = true
            next
          end
          if label.name == "enhancement"
            enhancement_a.push dict
            added = true
            next
          end
        end
        issues_a.push dict unless added
      end
      [bugs_a, enhancement_a, issues_a]
    end
  end
end
