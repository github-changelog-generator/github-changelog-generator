module GitHubChangelogGenerator
  class Generator
    def initialize(options = nil)
      @options = options
    end

    # Parse issue and generate single line formatted issue line.
    #
    # Example output:
    # - Add coveralls integration [\#223](https://github.com/skywinder/github-changelog-generator/pull/223) ([skywinder](https://github.com/skywinder))
    #
    # @param [Hash] issue Fetched issue from GitHub
    # @return [String] Markdown-formatted single issue
    def get_string_for_issue(issue)
      encapsulated_title = encapsulate_string issue[:title]

      title_with_number = "#{encapsulated_title} [\\##{issue[:number]}](#{issue.html_url})"

      unless issue.pull_request.nil?
        if @options[:author]
          if issue.user.nil?
            title_with_number += " ({Null user})"
          else
            title_with_number += " ([#{issue.user.login}](#{issue.user.html_url}))"
          end
        end
      end
      title_with_number
    end

    def encapsulate_string(string)
      string.gsub! '\\', '\\\\'

      encpas_chars = %w(> * _ \( \) [ ] #)
      encpas_chars.each do |char|
        string.gsub! char, "\\#{char}"
      end

      string
    end
  end
end
