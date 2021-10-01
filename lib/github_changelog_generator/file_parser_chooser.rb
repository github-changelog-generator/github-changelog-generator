# frozen_string_literal: true

require "pathname"

module GitHubChangelogGenerator
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
end
