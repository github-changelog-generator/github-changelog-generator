module GitHubChangelogGenerator
  describe Generator do
    context "#exclude_issues_by_labels" do
      let(:label) {  double("the-bad-label", name: "BAD") }
      let(:issue) { double("the-issue-to-be-excluded", labels: [label]) }
      let(:issues) { [issue] }
      subject(:generator) { described_class.new(exclude_labels: %w(BAD BOO))}

      it "removes issues with labels in the exclude_label list" do
        result = generator.exclude_issues_by_labels(issues)

        expect(result).to be_empty
      end
    end
  end
end
