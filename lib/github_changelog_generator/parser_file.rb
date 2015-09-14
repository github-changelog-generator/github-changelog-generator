module GitHubChangelogGenerator
  class ParseFile
    def initialize(options)
      @options = options
    end

    def file
      File.expand_path(".github_changelog_generator")
    end

    def has_file?
      File.exists?(file)
    end

    def file_open
      File.open(file)
    end

    def parse!
      return false unless has_file?
      file_open.each do |line|
        key, value = line.split("=")
        key_sym = key.sub('-', '_').to_sym
        @options[key_sym] = value.gsub(/[\n\r]+/, '')
      end
    end
  end
end
