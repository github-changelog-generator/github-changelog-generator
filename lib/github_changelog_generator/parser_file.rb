require "pathname"

module GitHubChangelogGenerator
  ParserError = Class.new(StandardError)

  class ParserFile
    FILENAME = ".github_changelog_generator"

    attr_reader :file

    # @param options [Hash]
    # @param file [nil,IO]
    def initialize(options, file = read_default_file)
      @options = options
      @file = file
    end

    def read_default_file
      path = Pathname(File.expand_path(FILENAME))
      File.open(path) if path.exist?
    end

    # Set @options using configuration file lines.
    def parse!
      return unless file
      file.each_line { |line| parse_line!(line) }
      file.close
    end

    private

    def parse_line!(line)
      option_name, value = extract_pair(line)
      @options[option_key_for(option_name)] = convert_value(value, option_name)
    rescue
      raise ParserError, "Config file #{file} is incorrect in line \"#{line.gsub(/[\n\r]+/, '')}\""
    end

    # Returns a the option name as a symbol and its string value sans newlines.
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
