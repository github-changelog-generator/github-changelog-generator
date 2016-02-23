require 'pathname'

module GitHubChangelogGenerator
  ParserError = Class.new(StandardError)

  class ParserFile
    def initialize(options)
      @options = options
    end

    def parse!
      return unless file.exist?

      file.each_line { |line| parse_line!(line) }
    end

    private

    def file
      @file ||= Pathname(File.expand_path(@options[:params_file] || ".github_changelog_generator"))
    end

    def parse_line!(line)
      key_sym, value = extract_pair(line)
      value = true if value =~ /^(true|t|yes|y|1)$/i
      value = false if value =~ /^(false|f|no|n|0)$/i
      @options[key_sym] = value
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
  end
end
