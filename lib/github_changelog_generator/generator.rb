module GitHubChangelogGenerator
  class Generator

    def initialize(options)
      @options = options
    end

    def get_string_for_pull_request(pull_request)
      pull_request[:title].gsub! '>', '\>'
      pull_request[:title].gsub! '*', '\*'
      pull_request[:title].gsub! '_', '\_'

      merge = "#{@options[:merge_prefix]}#{pull_request[:title]} [\\##{pull_request[:number]}](#{pull_request.html_url})"
      if @options[:author]
        merge += " ([#{pull_request.user.login}](#{pull_request.user.html_url}))\n\n"
      else
        merge += "\n\n"
      end
      merge
    end

  end
end