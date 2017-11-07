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
    # @param [Hash, nil] older_tag Older tag, used for the links. Could be nil for last tag.
    # @return [String] Ready and parsed section
    def create_entry_for_tag(pull_requests, issues, newer_tag_name, newer_tag_link, newer_tag_time, older_tag_name) # rubocop:disable Metrics/ParameterLists
      github_site = @options[:github_site] || "https://github.com"
      project_url = "#{github_site}/#{@options[:user]}/#{@options[:project]}"

      set_sections_and_maps

      @content = generate_header(newer_tag_name, newer_tag_link, newer_tag_time, older_tag_name, project_url)

      @content += generate_body(pull_requests, issues)

      @content
    end

    private

    # Creates section objects and the label and section maps needed for
    # sorting
    def set_sections_and_maps
      @sections = if @options.configure_sections?
                    parse_sections(@options[:configure_sections])
                  elsif @options.add_sections?
                    default_sections.concat parse_sections(@options[:add_sections])
                  else
                    default_sections
                  end

      @lmap = label_map
      @smap = section_map
    end

    # Turns a string from the commandline into an array of Section objects
    #
    # @param [String, Hash] either string or hash describing sections
    # @return [Array] array of Section objects
    def parse_sections(sections_desc)
      require "json"

      sections_desc = sections_desc.to_json if sections_desc.class == Hash

      begin
        sections_json = JSON.parse(sections_desc)
      rescue JSON::ParserError => e
        raise "There was a problem parsing your JSON string for sections: #{e}"
      end

      sections_json.collect do |name, v|
        Section.new(name: name.to_s, prefix: v["prefix"], labels: v["labels"], options: @options)
      end
    end

    # Creates a hash map of labels => section objects
    #
    # @return [Hash] map of labels => section objects
    def label_map
      @sections.each_with_object({}) do |section_obj, memo|
        section_obj.labels.each do |label|
          memo[label] = section_obj.name
        end
      end
    end

    # Creates a hash map of 'section name' => section object
    #
    # @return [Hash] map of 'section name' => section object
    def section_map
      @sections.each_with_object({}) do |section, memo|
        memo[section.name] = section
      end
    end

    # It generates header text for an entry with specific parameters.
    #
    # @param [String] newer_tag_name - name of newer tag
    # @param [String] newer_tag_link - used for links. Could be same as #newer_tag_name or some specific value, like HEAD
    # @param [Time] newer_tag_time - time, when newer tag created
    # @param [String] older_tag_name - tag name, used for links.
    # @param [String] project_url - url for current project.
    # @return [String] - Header text for a changelog entry.
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
    # @returns [String] ready-to-go tag body
    def generate_body(pull_requests, issues)
      body = ""
      body += main_sections_to_log(pull_requests, issues)
      body += merged_section_to_log(pull_requests) if @options[:pulls] && @options[:add_pr_wo_labels]
      body
    end

    # Generates main sections for a tag
    #
    # @param [Array] pull_requests
    # @param [Array] issues
    # @return [string] ready-to-go sub-sections
    def main_sections_to_log(pull_requests, issues)
      if @options[:issues]
        sections_to_log = parse_by_sections(pull_requests, issues)

        sections_to_log.map(&:generate_content).join
      end
    end

    # Generates section for prs with no labels (for a tag)
    #
    # @param [Array] pull_requests
    # @return [string] ready-to-go sub-section
    def merged_section_to_log(pull_requests)
      merged = Section.new(name: "merged", prefix: @options[:merge_prefix], labels: [], issues: pull_requests, options: @options)
      @sections << merged unless @sections.find { |section| section.name == "merged" }
      merged.generate_content
    end

    # Set of default sections for backwards-compatibility/defaults
    #
    # @return [Array] array of Section objects
    def default_sections
      [
        Section.new(name: "breaking", prefix: @options[:breaking_prefix], labels: @options[:breaking_labels], options: @options),
        Section.new(name: "enhancements", prefix: @options[:enhancement_prefix], labels: @options[:enhancement_labels], options: @options),
        Section.new(name: "bugs", prefix: @options[:bug_prefix], labels: @options[:bug_labels], options: @options),
        Section.new(name: "issues", prefix: @options[:issue_prefix], labels: @options[:issue_labels], options: @options)
      ]
    end

    # This method sorts issues by types
    # (bugs, features, or just closed issues) by labels
    #
    # @param [Array] pull_requests
    # @param [Array] issues
    # @return [Hash] Mapping of filtered arrays: (Bugs, Enhancements, Breaking stuff, Issues)
    def parse_by_sections(pull_requests, issues)
      issues.each do |dict|
        added = false

        dict["labels"].each do |label|
          break if @lmap[label["name"]].nil?
          @smap[@lmap[label["name"]]].issues << dict
          added = true

          break if added
        end
        if @smap["issues"]
          @sections.find { |sect| sect.name == "issues" }.issues << dict unless added
        end
      end
      sort_pull_requests(pull_requests)
    end

    # This method iterates through PRs and sorts them into sections
    #
    # @param [Array] pull_requests
    # @param [Hash] sections
    # @return [Hash] sections
    def sort_pull_requests(pull_requests)
      added_pull_requests = []
      pull_requests.each do |pr|
        added = false

        pr["labels"].each do |label|
          break if @lmap[label["name"]].nil?
          @smap[@lmap[label["name"]]].issues << pr
          added_pull_requests << pr
          added = true

          break if added
        end
      end
      added_pull_requests.each { |req| pull_requests.delete(req) }
      @sections
    end

    def line_labels_for(issue)
      labels = if @options[:issue_line_labels] == ["ALL"]
                 issue["labels"]
               else
                 issue["labels"].select { |label| @options[:issue_line_labels].include?(label["name"]) }
               end
      labels.map { |label| " \[[#{label['name']}](#{label['url'].sub('api.github.com/repos', 'github.com')})\]" }.join("")
    end
  end
end
