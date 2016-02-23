describe GitHubChangelogGenerator::ParserFile do
  describe ".github_changelog_generator" do
    context "when no has file" do
      let(:options) { {} }
      let(:parse) { GitHubChangelogGenerator::ParserFile.new(options) }
      subject { parse.parse! }
      it { is_expected.to be_nil }
    end

    context "when file is empty" do
      let(:options) { { params_file: "spec/files/github_changelog_params_empty" } }
      let(:parse) { GitHubChangelogGenerator::ParserFile.new(options) }

      it "does not change the options" do
        expect { parse.parse! }.to_not change { options }
      end
    end

    context "when file is incorrect" do
      let(:options) { { params_file: "spec/files/github_changelog_params_incorrect" } }
      let(:options_before_change) { options.dup }
      let(:parse) { GitHubChangelogGenerator::ParserFile.new(options) }
      it { expect { parse.parse! }.to raise_error(GitHubChangelogGenerator::ParserError) }
    end

    context "when override default values" do
      let(:default_options) { GitHubChangelogGenerator::Parser.default_options }
      let(:options) { { params_file: "spec/files/github_changelog_params_override" }.merge(default_options) }
      let(:options_before_change) { options.dup }
      let(:parse) { GitHubChangelogGenerator::ParserFile.new(options) }

      it "changes the options" do
        expect { parse.parse! }.to change { options }
          .from(options_before_change)
          .to(options_before_change.merge(unreleased_label: "staging",
                                          unreleased: false,
                                          header: "=== Changelog ==="))
      end

      context "turns exclude-label into an Array", bug: '#327' do
        let(:options) {
          {
            params_file: 'spec/files/github_changelog_params_327'
          }
        }
        it "reads exclude_labels into an Array" do
          expect { parse.parse! }.to change { options[:exclude_labels] }
                                       .from(nil)
                                       .to(["73a91042-da6f-11e5-9335-1040f38d7f90", "7adf83b4-da6f-11e5-ae18-1040f38d7f90"])

        end
      end
    end
  end
end
