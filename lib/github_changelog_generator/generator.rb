module GitHubChangelogGenerator
  class Generator

    def initialize(options = nil)
      @options = options
    end

    def get_string_for_issue(issue)
      encapsulated_title = self.encapsulate_string issue[:title]

      merge = "#{encapsulated_title} [\\##{issue[:number]}](#{issue.html_url})"
      unless issue.pull_request.nil?
        if @options[:author]
          if issue.user.nil?
            merge += " ({Null user})\n\n"
          else
            merge += " ([#{issue.user.login}](#{issue.user.html_url}))\n\n"
          end
        end
      end
      merge += "\n"
    end

    def encapsulate_string(string)

      string.gsub! '\\', '\\\\'

      encpas_chars = %w(> * _ \( \) [ ])
      encpas_chars.each { |char|
        string.gsub! char, "\\#{char}"
      }

      string
    end

  end

end