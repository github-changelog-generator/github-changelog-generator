module GitHubChangelogGenerator
  class Generator
    # delete all labels with labels from @options[:exclude_labels] array
    # @param [Array] issues
    # @return [Array] filtered array
    def exclude_issues_by_labels(issues)
      unless @options[:exclude_labels].nil?
        issues = issues.select do |issue|
          var = issue.labels.map(&:name) & @options[:exclude_labels]
          !(var).any?
        end
      end
      issues
    end

    def filter_by_milestone(filtered_issues, newer_tag_name, src_array)
      filtered_issues.select! do |issue|
        # leave issues without milestones
        if issue.milestone.nil?
          true
        else
          # check, that this milestone in tag list:
          @all_tags.find { |tag| tag.name == issue.milestone.title }.nil?
        end
      end
      unless newer_tag_name.nil?

        # add missed issues (according milestones)
        issues_to_add = src_array.select do |issue|
          if issue.milestone.nil?
            false
          else
            # check, that this milestone in tag list:
            milestone_is_tag = @all_tags.find do |tag|
              tag.name == issue.milestone.title
            end

            if milestone_is_tag.nil?
              false
            else
              issue.milestone.title == newer_tag_name
            end
          end
        end

        filtered_issues |= issues_to_add
      end
      filtered_issues
    end

    # Method filter issues, that belong only specified tag range
    # @param [Array] array of issues to filter
    # @param [Symbol] hash_key key of date value default is :actual_date
    # @param [String] older_tag all issues before this tag date will be excluded. May be nil, if it's first tag
    # @param [String] newer_tag all issue after this tag will be excluded. May be nil for unreleased section
    # @return [Array] filtered issues
    def delete_by_time(array, hash_key = :actual_date, older_tag = nil, newer_tag = nil)
      fail ChangelogGeneratorError, "At least one of the tags should be not nil!".red if older_tag.nil? && newer_tag.nil?

      newer_tag_time = newer_tag && @fetcher.get_time_of_tag(newer_tag)
      older_tag_time = older_tag && @fetcher.get_time_of_tag(older_tag)

      array.select do |req|
        if req[hash_key]
          t = Time.parse(req[hash_key]).utc

          if older_tag_time.nil?
            tag_in_range_old = true
          else
            tag_in_range_old = t > older_tag_time
          end

          if newer_tag_time.nil?
            tag_in_range_new = true
          else
            tag_in_range_new = t <= newer_tag_time
          end

          tag_in_range = (tag_in_range_old) && (tag_in_range_new)

          tag_in_range
        else
          false
        end
      end
    end

    # This method fetches missing params for PR and filter them by specified options
    # It include add all PR's with labels from @options[:include_labels] array
    # And exclude all from :exclude_labels array.
    # @return [Array] filtered PR's
    def get_filtered_pull_requests
      filter_merged_pull_requests

      filtered_pull_requests = include_issues_by_labels(@pull_requests)

      filtered_pull_requests = exclude_issues_by_labels(filtered_pull_requests)

      if @options[:verbose]
        puts "Filtered pull requests: #{filtered_pull_requests.count}"
      end

      filtered_pull_requests
    end

    # This method filter only merged PR and
    # fetch missing required attributes for pull requests
    # :merged_at - is a date, when issue PR was merged.
    # More correct to use merged date, rather than closed date.
    def filter_merged_pull_requests
      print "Fetching merged dates...\r" if @options[:verbose]
      pull_requests = @fetcher.fetch_closed_pull_requests

      @pull_requests.each do |pr|
        fetched_pr = pull_requests.find do |fpr|
          fpr.number == pr.number
        end
        pr[:merged_at] = fetched_pr[:merged_at]
        pull_requests.delete(fetched_pr)
      end

      @pull_requests.select! do |pr|
        !pr[:merged_at].nil?
      end
    end

    # Include issues with labels, specified in :include_labels
    # @param [Array] issues to filter
    # @return [Array] filtered array of issues
    def include_issues_by_labels(issues)
      filtered_issues = @options[:include_labels].nil? ? issues : issues.select do |issue|
        labels = issue.labels.map(&:name) & @options[:include_labels]
        (labels).any?
      end

      if @options[:add_issues_wo_labels]
        issues_wo_labels = issues.select do |issue|
          !issue.labels.map(&:name).any?
        end
        filtered_issues |= issues_wo_labels
      end
      filtered_issues
    end

    # Return tags after filtering tags in lists provided by option: --between-tags & --exclude-tags
    #
    # @return [Array]
    def get_filtered_tags
      all_tags = @fetcher.get_all_tags
      filtered_tags = []
      if @options[:between_tags]
        @options[:between_tags].each do |tag|
          unless all_tags.include? tag
            puts "Warning: can't find tag #{tag}, specified with --between-tags option.".yellow
          end
        end
        filtered_tags = all_tags.select { |tag| @options[:between_tags].include? tag }
      end
      filtered_tags
    end

    # Filter issues according labels
    # @return [Array] Filtered issues
    def get_filtered_issues
      filtered_issues = include_issues_by_labels(@issues)

      filtered_issues = exclude_issues_by_labels(filtered_issues)

      puts "Filtered issues: #{filtered_issues.count}" if @options[:verbose]

      filtered_issues
    end
  end
end
