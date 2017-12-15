module GitHubChangelogGenerator
  # This class generates the content for a single section of a changelog entry.
  # It turns the tagged issues and PRs into a well-formatted list of changes to
  # be later incorporated into a changelog entry.
  #
  # @see GitHubChangelogGenerator::Entry
  class Section
    attr_accessor :name, :prefix, :issues, :labels

    def initialize(opts = {})
      @name = opts[:name]
      @prefix = opts[:prefix]
      @labels = opts[:labels] || []
      @issues = opts[:issues] || []
      @options = opts[:options] || Options.new({})
    end

    # @param [Array] issues List of issues on sub-section
    # @param [String] prefix Name of sub-section
    # @return [String] Generate section content
    def generate_content
      content = ""

      if @issues.any?
        content += "#{@prefix}\n\n" unless @options[:simple_list]
        @issues.each do |issue|
          merge_string = get_string_for_issue(issue)
          content += "- #{merge_string}\n"
        end
        content += "\n"
      end
      content
    end

    private

    # Parse issue and generate single line formatted issue line.
    #
    # Example output:
    # - Add coveralls integration [\#223](https://github.com/skywinder/github-changelog-generator/pull/223) (@skywinder)
    #
    # @param [Hash] issue Fetched issue from GitHub
    # @return [String] Markdown-formatted single issue
    def get_string_for_issue(issue)
      encapsulated_title = encapsulate_string issue["title"]

      title_with_number = "#{encapsulated_title} [\\##{issue['number']}](#{issue['html_url']})"
      if @options[:issue_line_labels].present?
        title_with_number = "#{title_with_number}#{line_labels_for(issue)}"
      end
      issue_line_with_user(title_with_number, issue)
    end

    def issue_line_with_user(line, issue)
      return line if !@options[:author] || issue["pull_request"].nil?

      user = issue["user"]
      return "#{line} ({Null user})" unless user

      if @options[:usernames_as_github_logins]
        "#{line} (@#{user['login']})"
      else
        "#{line} ([#{user['login']}](#{user['html_url']}))"
      end
    end

    ENCAPSULATED_CHARACTERS = %w(< > * _ \( \) [ ] #)

    # Encapsulate characters to make Markdown look as expected.
    #
    # @param [String] string
    # @return [String] encapsulated input string
    def encapsulate_string(string)
      string = string.gsub('\\', '\\\\')

      ENCAPSULATED_CHARACTERS.each do |char|
        string = string.gsub(char, "\\#{char}")
      end

      string
    end
  end
end
