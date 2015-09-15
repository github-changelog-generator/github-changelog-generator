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
      subject { parse.parse! }
      it { is_expected.to be_a(Hash) }
      it { is_expected.to eq(options) }
    end

    context "when file is incorrect" do
      let(:options) { { params_file: "spec/files/github_changelog_params_incorrect" } }
      let(:parse) { GitHubChangelogGenerator::ParserFile.new(options) }
      it { expect { fail.raise! }.to raise_error RuntimeError }
    end

    context "when override default values" do
      let(:options) { { params_file: "spec/files/github_changelog_params_override" }.merge(GitHubChangelogGenerator::Parser.get_default_options) }
      let(:parse) { GitHubChangelogGenerator::ParserFile.new(options) }
      subject { parse.parse! }
      it { is_expected.to be_a(Hash) }
      it { is_expected.to eq(options.merge(unreleased_label: "staging", unreleased: false)) }
    end
  end
end
