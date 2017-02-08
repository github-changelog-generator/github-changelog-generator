# frozen_string_literal: true
require_relative "../octo_fetcher"
require_relative "generator_generation"
require_relative "generator_fetcher"
require_relative "generator_processor"
require_relative "generator_tags"

module GitHubChangelogGenerator
  # Default error for ChangelogGenerator
  class ChangelogGeneratorError < StandardError
  end

  class Generator
    attr_accessor :options, :filtered_tags, :github, :tag_section_mapping, :sorted_tags

    # A Generator responsible for all logic, related with change log generation from ready-to-parse issues
    #
    # Example:
    #   generator = GitHubChangelogGenerator::Generator.new
    #   content = generator.compound_changelog
    def initialize(options = {})
      @options        = options
      @tag_times_hash = {}
      @fetcher        = GitHubChangelogGenerator::OctoFetcher.new(options)
    end

    def fetch_issues_and_pr
      issues, pull_requests = @fetcher.fetch_closed_issues_and_pr

      @pull_requests = options[:pulls] ? get_filtered_pull_requests(pull_requests) : []

      @issues = options[:issues] ? get_filtered_issues(issues) : []

      fetch_events_for_issues_and_pr
      detect_actual_closed_dates(@issues + @pull_requests)
    end

    # Encapsulate characters to make markdown look as expected.
    #
    # @param [String] string
    # @return [String] encapsulated input string
    def encapsulate_string(string)
      string.gsub! '\\', '\\\\'

      encpas_chars = %w(< > * _ \( \) [ ] #)
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
    # @param [Hash, nil] older_tag Older tag, used for the links. Could be nil for last tag.
    # @return [String] Ready and parsed section
    def create_log_for_tag(pull_requests, issues, newer_tag, older_tag = nil)
      newer_tag_link, newer_tag_name, newer_tag_time = detect_link_tag_time(newer_tag)

      github_site = options[:github_site] || "https://github.com"
      project_url = "#{github_site}/#{options[:user]}/#{options[:project]}"

      # If the older tag is nil, go back in time from the latest tag and find
      # the SHA for the first commit.
      older_tag_name =
        if older_tag.nil?
          @fetcher.commits_before(newer_tag_time).last["sha"]
        else
          older_tag["name"]
        end

      log = generate_header(newer_tag_name, newer_tag_link, newer_tag_time, older_tag_name, project_url)

      if options[:issues]
        # Generate issues:
        log += issues_to_log(issues, pull_requests)
      end

      if options[:pulls] && options[:add_pr_wo_labels]
        # Generate pull requests:
        log += generate_sub_section(pull_requests, options[:merge_prefix])
      end

      log
    end

    # Generate ready-to-paste log from list of issues and pull requests.
    #
    # @param [Array] issues
    # @param [Array] pull_requests
    # @return [String] generated log for issues
    def issues_to_log(issues, pull_requests)
      log = ""
      bugs_a, enhancement_a, issues_a = parse_by_sections(issues, pull_requests)

      log += generate_sub_section(enhancement_a, options[:enhancement_prefix])
      log += generate_sub_section(bugs_a, options[:bug_prefix])
      log += generate_sub_section(issues_a, options[:issue_prefix])
      log
    end

    # This method sort issues by types
    # (bugs, features, or just closed issues) by labels
    #
    # @param [Array] issues
    # @param [Array] pull_requests
    # @return [Array] tuple of filtered arrays: (Bugs, Enhancements Issues)
    def parse_by_sections(issues, pull_requests)
      issues_a = []
      enhancement_a = []
      bugs_a = []

      issues.each do |dict|
        added = false
        dict["labels"].each do |label|
          if options[:bug_labels].include?(label["name"])
            bugs_a.push(dict)
            added = true
            next
          end
          if options[:enhancement_labels].include?(label["name"])
            enhancement_a.push(dict)
            added = true
            next
          end
        end
        issues_a.push(dict) unless added
      end

      added_pull_requests = []
      pull_requests.each do |pr|
        pr["labels"].each do |label|
          if options[:bug_labels].include?(label["name"])
            bugs_a.push(pr)
            added_pull_requests.push(pr)
            next
          end
          if options[:enhancement_labels].include?(label["name"])
            enhancement_a.push(pr)
            added_pull_requests.push(pr)
            next
          end
        end
      end
      added_pull_requests.each { |p| pull_requests.delete(p) }

      [bugs_a, enhancement_a, issues_a]
    end
  end
end
