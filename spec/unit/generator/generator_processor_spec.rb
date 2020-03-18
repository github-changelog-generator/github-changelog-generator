# frozen_string_literal: true

module GitHubChangelogGenerator
  describe Generator do
    let(:default_options) { GitHubChangelogGenerator::Parser.default_options.merge(verbose: false) }
    let(:options) { {} }
    let(:generator) { described_class.new(default_options.merge(options)) }
    let(:bad_label) { { "name" => "BAD" } }
    let(:good_label) { { "name" => "GOOD" } }

    describe "pull requests" do
      let(:bad_pull_request) { { "pull_request" => {}, "labels" => [bad_label] } }
      let(:good_pull_request) { { "pull_request" => {}, "labels" => [good_label] } }
      let(:unlabeled_pull_request) { { "pull_request" => {}, "labels" => [] } }
      let(:pull_requests) { [bad_pull_request, good_pull_request, unlabeled_pull_request] }

      describe "#filter_wo_labels" do
        subject do
          generator.filter_wo_labels(pull_requests)
        end

        let(:expected_pull_requests) { pull_requests }

        it { is_expected.to eq(expected_pull_requests) }

        context "when 'add_pr_wo_labels' is false" do
          let(:options) { { add_pr_wo_labels: false } }
          let(:expected_pull_requests) { [bad_pull_request, good_pull_request] }

          it { is_expected.to eq(expected_pull_requests) }
        end

        context "when 'add_pr_wo_labels' is true" do
          let(:options) { { add_pr_wo_labels: true } }

          it { is_expected.to eq(expected_pull_requests) }
        end
      end
    end

    describe "issues" do
      let(:bad_issue) { { "labels" => [bad_label] } }
      let(:good_issue) { { "labels" => [good_label] } }
      let(:unlabeled_issue) { { "labels" => [] } }
      let(:issues) { [bad_issue, good_issue, unlabeled_issue] }

      describe "#filter_wo_labels" do
        subject do
          generator.filter_wo_labels(issues)
        end

        let(:expected_issues) { issues }

        it { is_expected.to eq(expected_issues) }

        context "when 'add_issues_wo_labels' is false" do
          let(:options) { { add_issues_wo_labels: false } }
          let(:expected_issues) { [bad_issue, good_issue] }

          it { is_expected.to eq(expected_issues) }
        end

        context "when 'add_issues_wo_labels' is true" do
          let(:options) { { add_issues_wo_labels: true } }

          it { is_expected.to eq(expected_issues) }
        end
      end

      describe "#exclude_issues_by_labels" do
        subject do
          generator.exclude_issues_by_labels(issues)
        end

        let(:expected_issues) { issues }

        it { is_expected.to eq(expected_issues) }

        context "when 'exclude_labels' is provided" do
          let(:options) { { exclude_labels: %w[BAD BOO] } }
          let(:expected_issues) { [good_issue, unlabeled_issue] }

          it { is_expected.to eq(expected_issues) }
        end

        context "with no option given" do
          subject(:generator) { described_class.new }
          it "passes everything through when no option given" do
            result = generator.exclude_issues_by_labels(issues)

            expect(result).to eq(issues)
          end
        end
      end

      describe "#get_filtered_issues" do
        subject do
          generator.get_filtered_issues(issues)
        end

        let(:expected_issues) { issues }

        it { is_expected.to eq(expected_issues) }

        context "when 'exclude_labels' is provided" do
          let(:options) { { exclude_labels: %w[BAD BOO] } }
          let(:expected_issues) { [good_issue, unlabeled_issue] }

          it { is_expected.to eq(expected_issues) }
        end

        context "when 'add_issues_wo_labels' is false" do
          let(:options) { { add_issues_wo_labels: false } }
          let(:expected_issues) { [bad_issue, good_issue] }

          it { is_expected.to eq(expected_issues) }

          context "with 'exclude_labels'" do
            let(:options) { { add_issues_wo_labels: false, exclude_labels: %w[GOOD] } }
            let(:expected_issues) { [bad_issue] }

            it { is_expected.to eq(expected_issues) }
          end

          context "with 'include_labels'" do
            let(:options) { { add_issues_wo_labels: false, include_labels: %w[GOOD] } }
            let(:expected_issues) { [good_issue] }

            it { is_expected.to eq(expected_issues) }
          end
        end

        context "when 'include_labels' is specified" do
          let(:options) { { include_labels: %w[GOOD] } }
          let(:expected_issues) { [good_issue, unlabeled_issue] }

          it { is_expected.to eq(expected_issues) }
        end
      end
    end
  end
end
