require "pathname"

module GitHubChangelogGenerator
  ParserError = Class.new(StandardError)

  class ParserFile
    FILENAME = ".github_changelog_generator"

    def initialize(options)
      @options = options
    end

    # Destructively change @options using data in configured options file.
    def parse!
      file.each_line { |line| parse_line!(line) } if file.exist?
    end

    private

    def file
      @file ||= Pathname(File.expand_path(@options[:params_file] || FILENAME))
    end

    def parse_line!(line)
      key_sym, value = extract_pair(line)
      @options[translate_option_name(key_sym)] = convert_value(value, key_sym)
    rescue
      raise ParserError, "Config file #{file} is incorrect in line \"#{line.gsub(/[\n\r]+/, '')}\""
    end

    # Returns a the setting as a symbol and its string value sans newlines.
    #
    # @param line [String] unparsed line from config file
    # @return [Array<Symbol, String>]
    def extract_pair(line)
      key, value = line.split("=", 2)
      [key.sub("-", "_").to_sym, value.gsub(/[\n\r]+/, "")]
    end

    KNOWN_ARRAY_KEYS = [:exclude_labels, :include_labels, :bug_labels,
                        :enhancement_labels, :between_tags, :exclude_tags]
    KNOWN_INTEGER_KEYS = [:max_issues]

    def convert_value(value, key_sym)
      if KNOWN_ARRAY_KEYS.include?(key_sym)
        value.split(",")
      elsif KNOWN_INTEGER_KEYS.include?(key_sym)
        value.to_i
      elsif value =~ /^(true|t|yes|y|1)$/i
        true
      elsif value =~ /^(false|f|no|n|0)$/i
        false
      else
        value
      end
    end

    def translate_option_name(key_sym)
      {
        bugs_label: :bug_prefix,
        enhancement_label: :enhancement_prefix,
        issues_label: :issue_prefix,
        header_label: :header,
        front_matter: :frontmatter,
        pr_label: :merge_prefix,
        issues_wo_labels: :add_issues_wo_labels,
        pr_wo_labels: :add_pr_wo_labels,
        pull_requests: :pulls,
        filter_by_milestone: :filter_issues_by_milestone,
        github_api: :github_endpoint
      }.fetch(key_sym) { key_sym }
    end
  end
end
