# frozen_string_literal: true

require "pathname"

module GitHubChangelogGenerator
  ParserError = Class.new(StandardError)

  class FileParserChooser
    def initialize(options)
      @options     = options
      @config_file = Pathname.new(options[:config_file])
    end

    def parse!(_argv)
      return nil unless (path = resolve_path)

      ParserFile.new(@options, File.open(path)).parse!
    end

    def resolve_path
      return @config_file if @config_file.exist?

      path = @config_file.expand_path
      return path if File.exist?(path)

      nil
    end
  end

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
    # @param io [nil, IO] configuration file handle
    def initialize(options, io = nil)
      @options = options
      @io = io
    end

    # Sets options using configuration file content
    def parse!
      return unless @io

      @io.each_with_index { |line, i| parse_line!(line, i + 1) }
      @io.close
    end

    private

    def parse_line!(line, line_number)
      return if non_configuration_line?(line)

      option_name, value = extract_pair(line)
      @options[option_key_for(option_name)] = convert_value(value, option_name)
    rescue StandardError
      raise ParserError, "Failed on line ##{line_number}: \"#{line.gsub(/[\n\r]+/, '')}\""
    end

    # Returns true if the line starts with a pound sign or a semi-colon.
    def non_configuration_line?(line)
      line =~ /^[\#;]/ || line =~ /^\s+$/
    end

    # Returns a the option name as a symbol and its string value sans newlines.
    #
    # @param line [String] unparsed line from config file
    # @return [Array<Symbol, String>]
    def extract_pair(line)
      key, value = line.split("=", 2)
      [key.tr("-", "_").to_sym, value.gsub(/[\n\r]+/, "")]
    end

    KNOWN_ARRAY_KEYS = %i[exclude_labels include_labels
                          summary_labels breaking_labels enhancement_labels bug_labels
                          deprecated_labels removed_labels security_labels
                          issue_line_labels between_tags exclude_tags]
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
      breaking_label: :breaking_prefix,
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
