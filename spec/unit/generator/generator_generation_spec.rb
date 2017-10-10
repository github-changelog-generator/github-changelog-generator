# frozen_string_literal: true

module GitHubChangelogGenerator
  describe Generator do
    describe "#get_string_for_issue" do
      let(:issue) do
        { "title" => "Bug in code" }
      end

      it "formats an issue according to options" do
        expect do
          described_class.new.get_string_for_issue(issue)
        end.not_to raise_error
      end
    end

    describe "#parse_by_sections" do
      def label(name)
        { "name" => name }
      end

      def issue(title, labels)
        { "title" => "issue #{title}", "labels" => labels.map { |l| label(l) } }
      end

      def pr(title, labels)
        { "title" => "pr #{title}", "labels" => labels.map { |l| label(l) } }
      end

      def get_titles(issues)
        issues.map { |issue| issue["title"] }
      end

      let(:options) do
        {
          bug_labels: ["bug"],
          enhancement_labels: ["enhancement"],
          breaking_labels: ["breaking"]
        }
      end

      let(:issues) do
        [
          issue("no labels", []),
          issue("enhancement", ["enhancement"]),
          issue("bug", ["bug"]),
          issue("breaking", ["breaking"]),
          issue("all the labels", %w[enhancement bug breaking])
        ]
      end

      let(:pull_requests) do
        [
          pr("no labels", []),
          pr("enhancement", ["enhancement"]),
          pr("bug", ["bug"]),
          pr("breaking", ["breaking"]),
          pr("all the labels", %w[enhancement bug breaking])
        ]
      end

      it "works" do
        sections = described_class.new(options).parse_by_sections(issues, pull_requests)

        expect(get_titles(sections[:issues])).to eq(["issue no labels"])
        expect(get_titles(sections[:enhancements])).to eq(["issue enhancement", "issue all the labels", "pr enhancement", "pr all the labels"])
        expect(get_titles(sections[:bugs])).to eq(["issue bug", "pr bug"])
        expect(get_titles(sections[:breaking])).to eq(["issue breaking", "pr breaking"])
        expect(get_titles(pull_requests)).to eq(["pr no labels"])
      end
    end
  end
end
