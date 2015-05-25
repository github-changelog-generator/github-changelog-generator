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

      fetch_tags

      fetch_issues_and_pr
    end

    def fetch_issues_and_pr
      issues, pull_requests = @fetcher.fetch_closed_issues_and_pr

      @pull_requests = @options[:pulls] ? get_filtered_pull_requests(pull_requests) : []

      @issues = @options[:issues] ? get_filtered_issues(issues) : []

      fetch_events_for_issues_and_pr
      detect_actual_closed_dates(@issues + @pull_requests)
    end

    def fetch_tags
      # @all_tags = get_filtered_tags
      @all_tags = @fetcher.get_all_tags

      fetch_tags_dates
      sort_tags_by_date
    end

    # Sort all tags by date
    def sort_tags_by_date
      puts "Sorting tags..." if @options[:verbose]
      @all_tags.sort_by! { |x| @fetcher.get_time_of_tag(x) }.reverse!
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
      newer_tag_link, newer_tag_name, newer_tag_time = detect_link_tag_time(newer_tag)

      github_site = options[:github_site] || "https://github.com"
      project_url = "#{github_site}/#{@options[:user]}/#{@options[:project]}"

      log = generate_header(newer_tag_name, newer_tag_link, newer_tag_time, older_tag_name, project_url)

      if @options[:issues]
        # Generate issues:
        log += issues_to_log(issues)
      end

      if @options[:pulls]
        # Generate pull requests:
        log += generate_sub_section(pull_requests, @options[:merge_prefix])
      end

      log
    end

    # Detect link, name and time for specified tag.
    #
    # @param [Hash] newer_tag newer tag. Can be nil, if it's Unreleased section.
    # @return [Array] link, name and time of the tag
    def detect_link_tag_time(newer_tag)
      # if tag is nil - set current time
      newer_tag_time = newer_tag.nil? ? Time.new : @fetcher.get_time_of_tag(newer_tag)

      # if it's future release tag - set this value
      if newer_tag.nil? && @options[:future_release]
        newer_tag_name = @options[:future_release]
        newer_tag_link = @options[:future_release]
      else
        # put unreleased label if there is no name for the tag
        newer_tag_name = newer_tag.nil? ? @options[:unreleased_label] : newer_tag["name"]
        newer_tag_link = newer_tag.nil? ? "HEAD" : newer_tag_name
      end
      [newer_tag_link, newer_tag_name, newer_tag_time]
    end

    # Generate ready-to-paste log from list of issues.
    #
    # @param [Array] issues
    # @return [String] generated log for issues
    def issues_to_log(issues)
      log = ""
      bugs_a, enhancement_a, issues_a = parse_by_sections(issues)

      log += generate_sub_section(enhancement_a, @options[:enhancement_prefix])
      log += generate_sub_section(bugs_a, @options[:bug_prefix])
      log += generate_sub_section(issues_a, @options[:issue_prefix])
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
