module GitHubChangelogGenerator
  class Generator

    def initialize(options = nil)
      @options = options
    end

    def get_string_for_pull_request(pull_request)
      encapsulated_title = self.encapsulate_string pull_request[:title]

      merge = "#{encapsulated_title} [\\##{pull_request[:number]}](#{pull_request.html_url})"
      if @options[:author]
        if pull_request.user.nil?
          merge += " ({Null user})\n\n"
        else
          merge += " ([#{pull_request.user.login}](#{pull_request.user.html_url}))\n\n"
        end
      else
        merge += "\n\n"
      end
      merge
    end

    def encapsulate_string(string)

      string.gsub! '\\', '\\\\'

      encpas_chars = %w(> * _ \( \) [ ])
      encpas_chars.each{ |char|
        string.gsub! char, "\\#{char}"
      }

      string
    end

  end

end