# frozen_string_literal: true

module GitHubChangelogGenerator
  # This class generates the content for a single section of a changelog entry.
  # It turns the tagged issues and PRs into a well-formatted list of changes to
  # be later incorporated into a changelog entry.
  #
  # @see GitHubChangelogGenerator::Entry
  class Section
    # @return [String]
    attr_accessor :name

    # @return [String] a merge prefix, or an issue prefix
    attr_reader :prefix

    # @return [Array<Hash>]
    attr_reader :issues

    # @return [Array<String>]
    attr_reader :labels

    # @return [Boolean]
    attr_reader :body_only

    # @return [Options]
    attr_reader :options

    def initialize(opts = {})
      @name = opts[:name]
      @prefix = opts[:prefix]
      @labels = opts[:labels] || []
      @issues = opts[:issues] || []
      @options = opts[:options] || Options.new({})
      @body_only = opts[:body_only] || false
      @entry = Entry.new(options)
    end

    # Returns the content of a section.
    #
    # @return [String] Generated section content
    def generate_content
      content = ""

      if @issues.any?
        content += "#{@prefix}\n\n" unless @options[:simple_list] || @prefix.blank?
        @issues.each do |issue|
          merge_string = get_string_for_issue(issue)
          content += "- " unless @body_only
          content += "#{merge_string}\n"
        end
        content += "\n"
      end
      content
    end

    private

    # Parse issue and generate single line formatted issue line.
    #
    # Example output:
    # - Add coveralls integration [\#223](https://github.com/github-changelog-generator/github-changelog-generator/pull/223) (@github-changelog-generator)
    #
    # @param [Hash] issue Fetched issue from GitHub
    # @return [String] Markdown-formatted single issue
    def get_string_for_issue(issue)
      encapsulated_title = encapsulate_string issue["title"]

      title_with_number = "#{encapsulated_title} [\\##{issue['number']}](#{issue['html_url']})"
      title_with_number = "#{title_with_number}#{@entry.line_labels_for(issue)}" if @options[:issue_line_labels].present?
      line = issue_line_with_user(title_with_number, issue)
      issue_line_with_body(line, issue)
    end

    def issue_line_with_body(line, issue)
      return issue["body"] if @body_only && issue["body"].present?
      return line if !@options[:issue_line_body] || issue["body"].blank?

      # get issue body till first line break
      body_paragraph = body_till_first_break(issue["body"])
      # remove spaces from beginning of the string
      body_paragraph.rstrip!
      # encapsulate to md
      encapsulated_body = "  \n#{encapsulate_string(body_paragraph)}"

      "**#{line}** #{encapsulated_body}"
    end

    def body_till_first_break(body)
      body.split(/\n/, 2).first
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
        # Only replace char with escaped version if it isn't inside backticks (markdown inline code).
        # This relies on each opening '`' being closed (ie an even number in total).
        # A char is *outside* backticks if there is an even number of backticks following it.
        string = string.gsub(%r{#{Regexp.escape(char)}(?=([^`]*`[^`]*`)*[^`]*$)}, "\\#{char}")
      end

      string
    end
  end
end
