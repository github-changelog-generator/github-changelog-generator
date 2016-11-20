# frozen_string_literal: true
module GitHubChangelogGenerator
  class Generator
    # fetch, filter tags, fetch dates and sort them in time order
    def fetch_and_filter_tags
      detect_since_tag
      detect_due_tag

      all_tags = @fetcher.get_all_tags
      fetch_tags_dates(all_tags) # Creates a Hash @tag_times_hash
      all_sorted_tags = sort_tags_by_date(all_tags)

      @sorted_tags   = filter_excluded_tags(all_sorted_tags)
      @filtered_tags = get_filtered_tags(@sorted_tags)

      # Because we need to properly create compare links, we need a sorted list
      # of all filtered tags (including the excluded ones). We'll exclude those
      # tags from section headers inside the mapping function.
      section_tags = get_filtered_tags(all_sorted_tags)

      @tag_section_mapping = build_tag_section_mapping(section_tags, @filtered_tags)

      @filtered_tags
    end

    # @param [Array] section_tags are the tags that need a subsection output
    # @param [Array] filtered_tags is the list of filtered tags ordered from newest -> oldest
    # @return [Hash] key is the tag to output, value is an array of [Left Tag, Right Tag]
    # PRs to include in this section will be >= [Left Tag Date] and <= [Right Tag Date]
    # rubocop:disable Style/For - for allows us to be more concise
    def build_tag_section_mapping(section_tags, filtered_tags)
      tag_mapping = {}
      for i in 0..(section_tags.length - 1)
        tag = section_tags[i]

        # Don't create section header for the "since" tag
        next if @since_tag && tag["name"] == @since_tag

        # Don't create a section header for the first tag in between_tags
        next if options[:between_tags] && tag == section_tags.last

        # Don't create a section header for excluded tags
        next unless filtered_tags.include?(tag)

        older_tag = section_tags[i + 1]
        tag_mapping[tag] = [older_tag, tag]
      end
      tag_mapping
    end
    # rubocop:enable Style/For

    # Sort all tags by date, newest to oldest
    def sort_tags_by_date(tags)
      puts "Sorting tags..." if options[:verbose]
      tags.sort_by! do |x|
        get_time_of_tag(x)
      end.reverse!
    end

    # Returns date for given GitHub Tag hash
    #
    # Memoize the date by tag name.
    #
    # @param [Hash] tag_name
    #
    # @return [Time] time of specified tag
    def get_time_of_tag(tag_name)
      raise ChangelogGeneratorError, "tag_name is nil" if tag_name.nil?

      name_of_tag = tag_name.fetch("name")
      time_for_tag_name = @tag_times_hash[name_of_tag]
      return time_for_tag_name if time_for_tag_name

      @fetcher.fetch_date_of_tag(tag_name).tap do |time_string|
        @tag_times_hash[name_of_tag] = time_string
      end
    end

    # Detect link, name and time for specified tag.
    #
    # @param [Hash] newer_tag newer tag. Can be nil, if it's Unreleased section.
    # @return [Array] link, name and time of the tag
    def detect_link_tag_time(newer_tag)
      # if tag is nil - set current time
      newer_tag_time = newer_tag.nil? ? Time.new : get_time_of_tag(newer_tag)

      # if it's future release tag - set this value
      if newer_tag.nil? && options[:future_release]
        newer_tag_name = options[:future_release]
        newer_tag_link = options[:future_release]
      else
        # put unreleased label if there is no name for the tag
        newer_tag_name = newer_tag.nil? ? options[:unreleased_label] : newer_tag["name"]
        newer_tag_link = newer_tag.nil? ? "HEAD" : newer_tag_name
      end
      [newer_tag_link, newer_tag_name, newer_tag_time]
    end

    # @return [Object] try to find newest tag using #Reader and :base option if specified otherwise returns nil
    def detect_since_tag
      @since_tag ||= options.fetch(:since_tag) { version_of_first_item }
    end

    def detect_due_tag
      @due_tag ||= options.fetch(:due_tag, nil)
    end

    def version_of_first_item
      return unless File.file?(options[:base].to_s)

      sections = GitHubChangelogGenerator::Reader.new.read(options[:base])
      sections.first["version"] if sections && sections.any?
    end

    # Return tags after filtering tags in lists provided by option: --between-tags & --exclude-tags
    #
    # @return [Array]
    def get_filtered_tags(all_tags)
      filtered_tags = filter_since_tag(all_tags)
      filtered_tags = filter_due_tag(filtered_tags)
      filter_between_tags(filtered_tags)
    end

    # @param [Array] all_tags all tags
    # @return [Array] filtered tags according :since_tag option
    def filter_since_tag(all_tags)
      filtered_tags = all_tags
      tag = detect_since_tag
      if tag
        if all_tags.map { |t| t["name"] }.include? tag
          idx = all_tags.index { |t| t["name"] == tag }
          filtered_tags = if idx > 0
                            all_tags[0..idx]
                          else
                            []
                          end
        else
          Helper.log.warn "Warning: can't find tag #{tag}, specified with --since-tag option."
        end
      end
      filtered_tags
    end

    # @param [Array] all_tags all tags
    # @return [Array] filtered tags according :due_tag option
    def filter_due_tag(all_tags)
      filtered_tags = all_tags
      tag           = detect_due_tag
      if tag
        if all_tags.any? && all_tags.map { |t| t["name"] }.include?(tag)
          idx = all_tags.index { |t| t["name"] == tag }
          filtered_tags = if idx > 0
                            all_tags[(idx + 1)..-1]
                          else
                            []
                          end
        else
          Helper.log.warn "Warning: can't find tag #{tag}, specified with --due-tag option."
        end
      end
      filtered_tags
    end

    # @param [Array] all_tags all tags
    # @return [Array] filtered tags according :between_tags option
    def filter_between_tags(all_tags)
      filtered_tags = all_tags
      tag_names     = filtered_tags.map { |ft| ft["name"] }

      if options[:between_tags]
        options[:between_tags].each do |tag|
          unless tag_names.include?(tag)
            Helper.log.warn "Warning: can't find tag #{tag}, specified with --between-tags option."
          end
        end
        filtered_tags = all_tags.select { |tag| options[:between_tags].include?(tag["name"]) }
      end
      filtered_tags
    end

    # @param [Array] all_tags all tags
    # @return [Array] filtered tags according :exclude_tags or :exclude_tags_regex option
    def filter_excluded_tags(all_tags)
      if options[:exclude_tags]
        apply_exclude_tags(all_tags)
      elsif options[:exclude_tags_regex]
        apply_exclude_tags_regex(all_tags)
      else
        all_tags
      end
    end

    private

    def apply_exclude_tags(all_tags)
      if options[:exclude_tags].is_a?(Regexp)
        filter_tags_with_regex(all_tags, options[:exclude_tags])
      else
        filter_exact_tags(all_tags)
      end
    end

    def apply_exclude_tags_regex(all_tags)
      filter_tags_with_regex(all_tags, Regexp.new(options[:exclude_tags_regex]))
    end

    def filter_tags_with_regex(all_tags, regex)
      warn_if_nonmatching_regex(all_tags)
      all_tags.reject { |tag| regex =~ tag["name"] }
    end

    def filter_exact_tags(all_tags)
      options[:exclude_tags].each do |tag|
        warn_if_tag_not_found(all_tags, tag)
      end
      all_tags.reject { |tag| options[:exclude_tags].include?(tag["name"]) }
    end

    def warn_if_nonmatching_regex(all_tags)
      unless all_tags.map { |t| t["name"] }.any? { |t| options[:exclude_tags] =~ t }
        Helper.log.warn "Warning: unable to reject any tag, using regex "\
                        "#{options[:exclude_tags].inspect} in --exclude-tags "\
                        "option."
      end
    end

    def warn_if_tag_not_found(all_tags, tag)
      unless all_tags.map { |t| t["name"] }.include?(tag)
        Helper.log.warn "Warning: can't find tag #{tag}, specified with --exclude-tags option."
      end
    end
  end
end
