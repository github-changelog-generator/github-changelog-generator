# frozen_string_literal: true
module GitHubChangelogGenerator
  class Generator
    # delete all labels with labels from options[:exclude_labels] array
    # @param [Array] issues
    # @return [Array] filtered array
    def exclude_issues_by_labels(issues)
      return issues if !options[:exclude_labels] || options[:exclude_labels].empty?

      issues.reject do |issue|
        labels = issue["labels"].map { |l| l["name"] }
        (labels & options[:exclude_labels]).any?
      end
    end

    # @return [Array] filtered issues accourding milestone
    def filter_by_milestone(filtered_issues, tag_name, all_issues)
      remove_issues_in_milestones(filtered_issues)
      unless tag_name.nil?
        # add missed issues (according milestones)
        issues_to_add = find_issues_to_add(all_issues, tag_name)

        filtered_issues |= issues_to_add
      end
      filtered_issues
    end

    # Add all issues, that should be in that tag, according milestone
    #
    # @param [Array] all_issues
    # @param [String] tag_name
    # @return [Array] issues with milestone #tag_name
    def find_issues_to_add(all_issues, tag_name)
      all_issues.select do |issue|
        if issue["milestone"].nil?
          false
        else
          # check, that this milestone in tag list:
          milestone_is_tag = @filtered_tags.find do |tag|
            tag["name"] == issue["milestone"]["title"]
          end

          if milestone_is_tag.nil?
            false
          else
            issue["milestone"]["title"] == tag_name
          end
        end
      end
    end

    # @return [Array] array with removed issues, that contain milestones with same name as a tag
    def remove_issues_in_milestones(filtered_issues)
      filtered_issues.select! do |issue|
        # leave issues without milestones
        if issue["milestone"].nil?
          true
        else
          # check, that this milestone in tag list:
          @filtered_tags.find { |tag| tag["name"] == issue["milestone"]["title"] }.nil?
        end
      end
    end

    # Method filter issues, that belong only specified tag range
    # @param [Array] issues issues to filter
    # @param [Symbol] hash_key key of date value default is :actual_date
    # @param [String] older_tag all issues before this tag date will be excluded. May be nil, if it's first tag
    # @param [String] newer_tag all issue after this tag will be excluded. May be nil for unreleased section
    # @return [Array] filtered issues
    def delete_by_time(issues, hash_key = "actual_date", older_tag = nil, newer_tag = nil)
      # in case if not tags specified - return unchanged array
      return issues if older_tag.nil? && newer_tag.nil?

      older_tag = ensure_older_tag(older_tag, newer_tag)

      newer_tag_time = newer_tag && get_time_of_tag(newer_tag)
      older_tag_time = older_tag && get_time_of_tag(older_tag)

      issues.select do |issue|
        if issue[hash_key]
          time = Time.parse(issue[hash_key].to_s).utc

          tag_in_range_old = tag_newer_old_tag?(older_tag_time, time)

          tag_in_range_new = tag_older_new_tag?(newer_tag_time, time)

          tag_in_range = tag_in_range_old && tag_in_range_new

          tag_in_range
        else
          false
        end
      end
    end

    def ensure_older_tag(older_tag, newer_tag)
      return older_tag if older_tag
      idx = sorted_tags.index { |t| t["name"] == newer_tag["name"] }
      # skip if we are already at the oldest element
      return if idx == sorted_tags.size - 1
      sorted_tags[idx - 1]
    end

    def tag_older_new_tag?(newer_tag_time, time)
      tag_in_range_new = if newer_tag_time.nil?
                           true
                         else
                           time <= newer_tag_time
                         end
      tag_in_range_new
    end

    def tag_newer_old_tag?(older_tag_time, t)
      tag_in_range_old = if older_tag_time.nil?
                           true
                         else
                           t > older_tag_time
                         end
      tag_in_range_old
    end

    # Include issues with labels, specified in :include_labels
    # @param [Array] issues to filter
    # @return [Array] filtered array of issues
    def include_issues_by_labels(issues)
      filtered_issues = filter_by_include_labels(issues)
      filtered_issues = filter_wo_labels(filtered_issues)
      filtered_issues
    end

    # @return [Array] issues without labels or empty array if add_issues_wo_labels is false
    def filter_wo_labels(issues)
      if options[:add_issues_wo_labels]
        issues
      else
        issues.reject { |issue| !issue["labels"].map { |l| l["name"] }.any? }
      end
    end

    def filter_by_include_labels(issues)
      if options[:include_labels].nil?
        issues
      else
        issues.select do |issue|
          labels = issue["labels"].map { |l| l["name"] } & options[:include_labels]
          labels.any?
        end
      end
    end

    # General filtered function
    #
    # @param [Array] all_issues
    # @return [Array] filtered issues
    def filter_array_by_labels(all_issues)
      filtered_issues = include_issues_by_labels(all_issues)
      exclude_issues_by_labels(filtered_issues)
    end

    # Filter issues according labels
    # @return [Array] Filtered issues
    def get_filtered_issues(issues)
      issues = filter_array_by_labels(issues)
      puts "Filtered issues: #{issues.count}" if options[:verbose]
      issues
    end

    # This method fetches missing params for PR and filter them by specified options
    # It include add all PR's with labels from options[:include_labels] array
    # And exclude all from :exclude_labels array.
    # @return [Array] filtered PR's
    def get_filtered_pull_requests(pull_requests)
      pull_requests = filter_array_by_labels(pull_requests)
      pull_requests = filter_merged_pull_requests(pull_requests)
      puts "Filtered pull requests: #{pull_requests.count}" if options[:verbose]
      pull_requests
    end

    # This method filter only merged PR and
    # fetch missing required attributes for pull requests
    # :merged_at - is a date, when issue PR was merged.
    # More correct to use merged date, rather than closed date.
    def filter_merged_pull_requests(pull_requests)
      print "Fetching merged dates...\r" if options[:verbose]
      closed_pull_requests = @fetcher.fetch_closed_pull_requests

      pull_requests.each do |pr|
        fetched_pr = closed_pull_requests.find do |fpr|
          fpr["number"] == pr["number"]
        end
        if fetched_pr
          pr["merged_at"] = fetched_pr["merged_at"]
          closed_pull_requests.delete(fetched_pr)
        end
      end

      pull_requests.select! do |pr|
        !pr["merged_at"].nil?
      end

      pull_requests
    end
  end
end
