module GitHubChangelogGenerator
  class Generator
    # @param [Array] issues List of issues on sub-section
    # @param [String] prefix Nae of sub-section
    # @return [String] Generate ready-to-go sub-section
    def generate_sub_section(issues, prefix)
      log = ""

      log += "#{prefix}\n\n" if options[:simple_list] != true && issues.any?

      if issues.any?
        issues.each do |issue|
          merge_string = get_string_for_issue(issue)
          log += "- #{merge_string}\n\n"
        end
      end
      log
    end

    # It generate one header for section with specific parameters.
    #
    # @param [String] newer_tag_name - name of newer tag
    # @param [String] newer_tag_link - used for links. Could be same as #newer_tag_name or some specific value, like HEAD
    # @param [Time] newer_tag_time - time, when newer tag created
    # @param [String] older_tag_link - tag name, used for links.
    # @param [String] project_url - url for current project.
    # @return [String] - Generate one ready-to-add section.
    def generate_header(newer_tag_name, newer_tag_link, newer_tag_time, older_tag_link, project_url)
      log = ""

      # Generate date string:
      time_string = newer_tag_time.strftime @options[:dateformat]

      # Generate tag name and link
      if newer_tag_name.equal? @options[:unreleased_label]
        log += "## [#{newer_tag_name}](#{project_url}/tree/#{newer_tag_link})\n\n"
      else
        log += "## [#{newer_tag_name}](#{project_url}/tree/#{newer_tag_link}) (#{time_string})\n\n"
      end

      if @options[:compare_link] && older_tag_link
        # Generate compare link
        log += "[Full Changelog](#{project_url}/compare/#{older_tag_link}...#{newer_tag_link})\n\n"
      end

      log
    end

    # Generate log only between 2 specified tags
    # @param [String] older_tag all issues before this tag date will be excluded. May be nil, if it's first tag
    # @param [String] newer_tag all issue after this tag will be excluded. May be nil for unreleased section
    def generate_log_between_tags(older_tag, newer_tag)
      filtered_pull_requests = delete_by_time(@pull_requests, :actual_date, older_tag, newer_tag)
      filtered_issues = delete_by_time(@issues, :actual_date, older_tag, newer_tag)

      newer_tag_name = newer_tag.nil? ? nil : newer_tag["name"]
      older_tag_name = older_tag.nil? ? nil : older_tag["name"]

      if @options[:filter_issues_by_milestone]
        # delete excess irrelevant issues (according milestones). Issue #22.
        filtered_issues = filter_by_milestone(filtered_issues, newer_tag_name, @issues)
        filtered_pull_requests = filter_by_milestone(filtered_pull_requests, newer_tag_name, @pull_requests)
      end

      if newer_tag.nil? && filtered_issues.empty? && filtered_pull_requests.empty?
        # do not generate empty unreleased section
        return ""
      end

      create_log(filtered_pull_requests, filtered_issues, newer_tag, older_tag_name)
    end

    # The full cycle of generation for whole project
    # @return [String] The complete change log
    def generate_log_for_all_tags
      fetch_tags_dates

      puts "Sorting tags..." if @options[:verbose]

      @all_tags.sort_by! { |x| @fetcher.get_time_of_tag(x) }.reverse!

      puts "Generating log..." if @options[:verbose]

      log = ""

      if @options[:unreleased] && @all_tags.count != 0
        unreleased_log = generate_log_between_tags(all_tags[0], nil)
        log += unreleased_log if unreleased_log
      end

      (1...all_tags.size).each do |index|
        log += generate_log_between_tags(all_tags[index], all_tags[index - 1])
      end
      if @all_tags.count != 0
        log += generate_log_between_tags(nil, all_tags.last)
      end

      log
    end
  end
end
