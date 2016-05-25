module GitHubChangelogGenerator
  describe Generator do
    context "#exclude_issues_by_labels" do
      let(:label) { { "name" => "BAD" } }
      let(:issue) { { "labels" => [label] } }
      let(:good_label) { { "name" => "GOOD" } }
      let(:good_issue) { { "labels" => [good_label] } }
      let(:issues) { [issue, good_issue] }
      subject(:generator) { described_class.new(exclude_labels: %w(BAD BOO)) }

      it "removes issues with labels in the exclude_label list" do
        result = generator.exclude_issues_by_labels(issues)

        expect(result).to include(good_issue)
        expect(result).not_to include(issue)
      end

      context "with no option given" do
        subject(:generator) { described_class.new }
        it "passes everything through when no option given" do
          result = generator.exclude_issues_by_labels(issues)

          expect(result).to eq(issues)
        end
      end
    end
  end
end
