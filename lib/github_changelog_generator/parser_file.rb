module GitHubChangelogGenerator
  class ParserFile
    def initialize(options)
      @options = options
    end

    def file
      File.expand_path(@options[:params_file] || ".github_changelog_generator")
    end

    def file?
      File.exist?(file)
    end

    def file_open
      File.open(file)
    end

    def parse!
      return unless file?
      file_open.each do |line|
        begin
          key, value = line.split("=")
          key_sym = key.sub("-", "_").to_sym
          value = value.gsub(/[\n\r]+/, "")
          value = true if value =~ (/^(true|t|yes|y|1)$/i)
          value = false if value =~ (/^(false|f|no|n|0)$/i)
          @options[key_sym] = value
        rescue
          raise "File #{file} is incorrect in line \"#{line.gsub(/[\n\r]+/, '')}\""
        end
      end
      @options
    end
  end
end
