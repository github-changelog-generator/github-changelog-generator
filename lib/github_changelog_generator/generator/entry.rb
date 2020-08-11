# frozen_string_literal: true

require "github_changelog_generator/generator/section"

module GitHubChangelogGenerator
  # This class generates the content for a single changelog entry. An entry is
  # generally either for a specific tagged release or the collection of
  # unreleased changes.
  #
  # An entry is comprised of header text followed by a series of sections
  # relating to the entry.
  #
  # @see GitHubChangelogGenerator::Generator
  # @see GitHubChangelogGenerator::Section
  class Entry
    attr_reader :content

    def initialize(options = Options.new({}))
      @content = ""
      @options = Options.new(options)
    end

    # Generates log entry with header and body
    #
    # @param [Array] pull_requests List or PR's in new section
    # @param [Array] issues List of issues in new section
    # @param [String] newer_tag_name Name of the newer tag. Could be nil for `Unreleased` section.
    # @param [String] newer_tag_link Name of the newer tag. Could be "HEAD" for `Unreleased` section.
    # @param [Time] newer_tag_time Time of the newer tag
    # @param [Hash, nil] older_tag_name Older tag, used for the links. Could be nil for last tag.
    # @return [String] Ready and parsed section content.
    def generate_entry_for_tag(pull_requests, issues, newer_tag_name, newer_tag_link, newer_tag_time, older_tag_name) # rubocop:disable Metrics/ParameterLists
      github_site = @options[:github_site] || "https://github.com"
      project_url = "#{github_site}/#{@options[:user]}/#{@options[:project]}"

      create_sections

      @content = generate_header(newer_tag_name, newer_tag_link, newer_tag_time, older_tag_name, project_url)
      @content += generate_body(pull_requests, issues)
      @content
    end

    def line_labels_for(issue)
      labels = if @options[:issue_line_labels] == ["ALL"]
                 issue["labels"]
               else
                 issue["labels"].select { |label| @options[:issue_line_labels].include?(label["name"]) }
               end
      labels.map { |label| " \[[#{label['name']}](#{label['url'].sub('api.github.com/repos', 'github.com')})\]" }.join("")
    end

    private

    # Creates section objects for this entry.
    # @return [Nil]
    def create_sections
      @sections = if @options.configure_sections?
                    parse_sections(@options[:configure_sections])
                  elsif @options.add_sections?
                    default_sections.concat parse_sections(@options[:add_sections])
                  else
                    default_sections
                  end
      nil
    end

    # Turns the argument from the commandline of --configure-sections or
    # --add-sections into an array of Section objects.
    #
    # @param [String, Hash] sections_desc Either string or hash describing sections
    # @return [Array] Parsed section objects.
    def parse_sections(sections_desc)
      require "json"

      sections_desc = sections_desc.to_json if sections_desc.class == Hash

      begin
        sections_json = JSON.parse(sections_desc)
      rescue JSON::ParserError => e
        raise "There was a problem parsing your JSON string for sections: #{e}"
      end

      sections_json.collect do |name, v|
        Section.new(name: name.to_s, prefix: v["prefix"], labels: v["labels"], body_only: v["body_only"], options: @options)
      end
    end

    # Generates header text for an entry.
    #
    # @param [String] newer_tag_name The name of a newer tag
    # @param [String] newer_tag_link Used for URL generation. Could be same as #newer_tag_name or some specific value, like HEAD
    # @param [Time] newer_tag_time Time when the newer tag was created
    # @param [String] older_tag_name The name of an older tag; used for URLs.
    # @param [String] project_url URL for the current project.
    # @return [String] Header text content.
    def generate_header(newer_tag_name, newer_tag_link, newer_tag_time, older_tag_name, project_url)
      header = ""

      # Generate date string:
      time_string = newer_tag_time.strftime(@options[:date_format])

      # Generate tag name and link
      release_url = if @options[:release_url]
                      format(@options[:release_url], newer_tag_link)
                    else
                      "#{project_url}/tree/#{newer_tag_link}"
                    end
      header += if newer_tag_name.equal?(@options[:unreleased_label])
                  "## [#{newer_tag_name}](#{release_url})\n\n"
                else
                  "## [#{newer_tag_name}](#{release_url}) (#{time_string})\n\n"
                end

      if @options[:compare_link] && older_tag_name
        # Generate compare link
        header += "[Full Changelog](#{project_url}/compare/#{older_tag_name}...#{newer_tag_link})\n\n"
      end

      header
    end

    # Generates complete body text for a tag (without a header)
    #
    # @param [Array] pull_requests
    # @param [Array] issues
    # @return [String] Content generated from sections of sorted issues & PRs.
    def generate_body(pull_requests, issues)
      sort_into_sections(pull_requests, issues)
      @sections.map(&:generate_content).join
    end

    # Default sections to used when --configure-sections is not set.
    #
    # @return [Array] Section objects.
    def default_sections
      [
        Section.new(name: "summary", prefix: @options[:summary_prefix], labels: @options[:summary_labels], options: @options, body_only: true),
        Section.new(name: "breaking", prefix: @options[:breaking_prefix], labels: @options[:breaking_labels], options: @options),
        Section.new(name: "enhancements", prefix: @options[:enhancement_prefix], labels: @options[:enhancement_labels], options: @options),
        Section.new(name: "bugs", prefix: @options[:bug_prefix], labels: @options[:bug_labels], options: @options),
        Section.new(name: "deprecated", prefix: @options[:deprecated_prefix], labels: @options[:deprecated_labels], options: @options),
        Section.new(name: "removed", prefix: @options[:removed_prefix], labels: @options[:removed_labels], options: @options),
        Section.new(name: "security", prefix: @options[:security_prefix], labels: @options[:security_labels], options: @options)
      ]
    end

    # Sorts issues and PRs into entry sections by labels and lack of labels.
    #
    # @param [Array] pull_requests
    # @param [Array] issues
    # @return [Nil]
    def sort_into_sections(pull_requests, issues)
      if @options[:issues]
        unmapped_issues = sort_labeled_issues(issues)
        add_unmapped_section(unmapped_issues)
      end
      if @options[:pulls]
        unmapped_pull_requests = sort_labeled_issues(pull_requests)
        add_unmapped_section(unmapped_pull_requests)
      end
      nil
    end

    # Iterates through sections and sorts labeled issues into them based on
    # the label mapping. Returns any unmapped or unlabeled issues.
    #
    # @param [Array] issues Issues or pull requests.
    # @return [Array] Issues that were not mapped into any sections.
    def sort_labeled_issues(issues)
      sorted_issues = []
      issues.each do |issue|
        label_names = issue["labels"].collect { |l| l["name"] }

        # Add PRs in the order of the @sections array. This will either be the
        # default sections followed by any --add-sections sections in
        # user-defined order, or --configure-sections in user-defined order.
        # Ignore the order of the issue labels from github which cannot be
        # controled by the user.
        @sections.each do |section|
          unless (section.labels & label_names).empty?
            section.issues << issue
            sorted_issues << issue
            break
          end
        end
      end
      issues - sorted_issues
    end

    # Creates a section for issues/PRs with no labels or no mapped labels.
    #
    # @param [Array] issues
    # @return [Nil]
    def add_unmapped_section(issues)
      unless issues.empty?
        # Distinguish between issues and pull requests
        if issues.first.key?("pull_request")
          name = "merged"
          prefix = @options[:merge_prefix]
          add_wo_labels = @options[:add_pr_wo_labels]
        else
          name = "issues"
          prefix = @options[:issue_prefix]
          add_wo_labels = @options[:add_issues_wo_labels]
        end
        add_issues = if add_wo_labels
                       issues
                     else
                       # Only add unmapped issues
                       issues.select { |issue| issue["labels"].any? }
                     end
        merged = Section.new(name: name, prefix: prefix, labels: [], issues: add_issues, options: @options) unless add_issues.empty?
        @sections << merged
      end
      nil
    end
  end
end
