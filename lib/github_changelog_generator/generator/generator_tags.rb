module GitHubChangelogGenerator
  class Generator
    # fetch, filter tags, fetch dates and sort them in time order
    def fetch_and_filter_tags
      @filtered_tags = get_filtered_tags(@fetcher.get_all_tags)
      fetch_tags_dates
    end

    # Sort all tags by date
    def sort_tags_by_date(tags)
      puts "Sorting tags..." if @options[:verbose]
      tags.sort_by! do |x|
        get_time_of_tag(x)
      end.reverse!
    end

    # Try to find tag date in local hash.
    # Otherwise fFetch tag time and put it to local hash file.
    # @param [Hash] tag_name name of the tag
    # @return [Time] time of specified tag
    def get_time_of_tag(tag_name)
      raise ChangelogGeneratorError, "tag_name is nil".red if tag_name.nil?

      name_of_tag = tag_name["name"]
      time_for_name = @tag_times_hash[name_of_tag]
      if !time_for_name.nil?
        time_for_name
      else
        time_string = @fetcher.fetch_date_of_tag tag_name
        @tag_times_hash[name_of_tag] = time_string
        time_string
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

    # @return [Object] try to find newest tag using #Reader and :base option if specified otherwise returns nil
    def detect_since_tag
      @since_tag ||= @options.fetch(:since_tag) { version_of_first_item }
    end

    def version_of_first_item
      return unless File.file?(@options[:base].to_s)

      sections = GitHubChangelogGenerator::Reader.new.read(@options[:base])
      sections.first["version"] if sections && sections.any?
    end

    # Return tags after filtering tags in lists provided by option: --between-tags & --exclude-tags
    #
    # @return [Array]
    def get_filtered_tags(all_tags)
      filtered_tags = filter_since_tag(all_tags)
      filtered_tags = filter_between_tags(filtered_tags)
      filter_excluded_tags(filtered_tags)
    end

    # @param [Array] all_tags all tags
    # @return [Array] filtered tags according :since_tag option
    def filter_since_tag(all_tags)
      filtered_tags = all_tags
      tag = detect_since_tag
      if tag
        if all_tags.map(&:name).include? tag
          idx = all_tags.index { |t| t.name == tag }
          filtered_tags = if idx > 0
                            all_tags[0..idx - 1]
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
      tag = @options[:due_tag]
      if tag
        if (all_tags.count > 0) && (all_tags.map(&:name).include? tag)
          idx = all_tags.index { |t| t.name == tag }
          last_index = all_tags.count - 1
          filtered_tags = if idx > 0 && idx < last_index
                            all_tags[idx + 1..last_index]
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
      if @options[:between_tags]
        @options[:between_tags].each do |tag|
          unless all_tags.map(&:name).include? tag
            Helper.log.warn "Warning: can't find tag #{tag}, specified with --between-tags option."
          end
        end
        filtered_tags = all_tags.select { |tag| @options[:between_tags].include? tag.name }
      end
      filtered_tags
    end

    # @param [Array] all_tags all tags
    # @return [Array] filtered tags according :exclude_tags or :exclude_tags_regex option
    def filter_excluded_tags(all_tags)
      if @options[:exclude_tags]
        apply_exclude_tags(all_tags)
      elsif @options[:exclude_tags_regex]
        apply_exclude_tags_regex(all_tags)
      else
        all_tags
      end
    end

    private

    def apply_exclude_tags(all_tags)
      if @options[:exclude_tags].is_a?(Regexp)
        filter_tags_with_regex(all_tags, @options[:exclude_tags])
      else
        filter_exact_tags(all_tags)
      end
    end

    def apply_exclude_tags_regex(all_tags)
      filter_tags_with_regex(all_tags, Regexp.new(@options[:exclude_tags_regex]))
    end

    def filter_tags_with_regex(all_tags, regex)
      warn_if_nonmatching_regex(all_tags)
      all_tags.reject { |tag| regex =~ tag.name }
    end

    def filter_exact_tags(all_tags)
      @options[:exclude_tags].each do |tag|
        warn_if_tag_not_found(all_tags, tag)
      end
      all_tags.reject { |tag| @options[:exclude_tags].include? tag.name }
    end

    def warn_if_nonmatching_regex(all_tags)
      unless all_tags.map(&:name).any? { |t| @options[:exclude_tags] =~ t }
        Helper.log.warn "Warning: unable to reject any tag, using regex "\
                        "#{@options[:exclude_tags].inspect} in --exclude-tags "\
                        "option."
      end
    end

    def warn_if_tag_not_found(all_tags, tag)
      unless all_tags.map(&:name).include? tag
        Helper.log.warn "Warning: can't find tag #{tag}, specified with --exclude-tags option."
      end
    end
  end
end
