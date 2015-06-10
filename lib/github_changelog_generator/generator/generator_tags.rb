module GitHubChangelogGenerator
  class Generator
    # fetch, filter tags, fetch dates and sort them in time order
    def fetch_and_filter_tags
      @all_tags = get_filtered_tags(@fetcher.get_all_tags)
      fetch_tags_dates
      sort_tags_by_date
    end

    # Sort all tags by date
    def sort_tags_by_date
      puts "Sorting tags..." if @options[:verbose]
      @all_tags.sort_by! { |x| @fetcher.get_time_of_tag(x) }.reverse!
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

    # Return tags after filtering tags in lists provided by option: --between-tags & --exclude-tags
    #
    # @return [Array]
    def get_filtered_tags(all_tags)
      filtered_tags = filter_between_tags(all_tags)
      filter_excluded_tags(filtered_tags)
    end

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

    def filter_excluded_tags(all_tags)
      filtered_tags = all_tags
      if @options[:exclude_tags]
        @options[:exclude_tags].each do |tag|
          unless all_tags.map(&:name).include? tag
            Helper.log.warn "Warning: can't find tag #{tag}, specified with --exclude-tags option."
          end
        end
        filtered_tags = all_tags.reject { |tag| @options[:exclude_tags].include? tag.name }
      end
      filtered_tags
    end
  end
end
