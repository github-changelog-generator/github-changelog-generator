# frozen_string_literal: true
require "pathname"

module GitHubChangelogGenerator
  ParserError = Class.new(StandardError)

  # ParserFile is a configuration file reader which sets options in the
  # given Hash.
  #
  # In your project's root, you can put a file named
  # <tt>.github_changelog_generator</tt> to override defaults.
  #
  # Example:
  #   header_label=# My Super Changelog
  #   ; Comments are allowed
  #   future-release=5.0.0
  #   # Ruby-style comments, too
  #   since-tag=1.0.0
  #
  # The configuration format is <tt>some-key=value</tt> or <tt>some_key=value</tt>.
  #
  class ParserFile
    # @param options [Hash] options to be configured from file contents
    # @param file [nil,IO] configuration file handle, defaults to opening `.github_changelog_generator`
    def initialize(options, file = open_settings_file)
      @options = options
      @file = file
    end

    # Sets options using configuration file content
    def parse!
      return unless @file
      @file.each_with_index { |line, i| parse_line!(line, i + 1) }
      @file.close
    end

    private

    FILENAME = ".github_changelog_generator"

    def open_settings_file
      path = Pathname(File.expand_path(FILENAME))
      File.open(path) if path.exist?
    end

    def parse_line!(line, line_number)
      return if non_configuration_line?(line)
      option_name, value = extract_pair(line)
      @options[option_key_for(option_name)] = convert_value(value, option_name)
    rescue
      raise ParserError, "Failed on line ##{line_number}: \"#{line.gsub(/[\n\r]+/, '')}\""
    end

    # Returns true if the line starts with a pound sign or a semi-colon.
    def non_configuration_line?(line)
      line =~ /^[\#;]/ || line =~ /^[\s]+$/
    end

    # Returns a the option name as a symbol and its string value sans newlines.
    #
    # @param line [String] unparsed line from config file
    # @return [Array<Symbol, String>]
    def extract_pair(line)
      key, value = line.split("=", 2)
      [key.tr("-", "_").to_sym, value.gsub(/[\n\r]+/, "")]
    end

    KNOWN_ARRAY_KEYS = [:exclude_labels, :include_labels, :bug_labels,
                        :enhancement_labels, :issue_line_labels, :between_tags, :exclude_tags]
    KNOWN_INTEGER_KEYS = [:max_issues]

    def convert_value(value, option_name)
      if KNOWN_ARRAY_KEYS.include?(option_name)
        value.split(",")
      elsif KNOWN_INTEGER_KEYS.include?(option_name)
        value.to_i
      elsif value =~ /^(true|t|yes|y|1)$/i
        true
      elsif value =~ /^(false|f|no|n|0)$/i
        false
      else
        value
      end
    end

    IRREGULAR_OPTIONS = {
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
    }

    def option_key_for(option_name)
      IRREGULAR_OPTIONS.fetch(option_name) { option_name }
    end
  end
end
