describe GitHubChangelogGenerator::Fetcher do
  VALID_TOKEN = "0123456789abcdef"
  before(:all) do
    @fetcher = GitHubChangelogGenerator::Fetcher.new
  end

  describe "#fetch_github_token" do
    token = GitHubChangelogGenerator::Fetcher::CHANGELOG_GITHUB_TOKEN
    context "when token in ENV exist" do
      before { stub_const("ENV", ENV.to_hash.merge(token => VALID_TOKEN)) }
      subject { @fetcher.fetch_github_token }
      it { is_expected.to eq(VALID_TOKEN) }
    end
    context "when token in ENV is nil" do
      before { stub_const("ENV", ENV.to_hash.merge(token => nil)) }
      subject { @fetcher.fetch_github_token }
      it { is_expected.to be_nil }
    end
    context "when token in options and ENV is nil" do
      before do
        stub_const("ENV", ENV.to_hash.merge(token => nil))
        @fetcher = GitHubChangelogGenerator::Fetcher.new(token: VALID_TOKEN)
      end
      subject { @fetcher.fetch_github_token }
      it { is_expected.to eq(VALID_TOKEN) }
    end
    context "when token in options and ENV specified" do
      before do
        stub_const("ENV", ENV.to_hash.merge(token => "no_matter_what"))
        @fetcher = GitHubChangelogGenerator::Fetcher.new(token: VALID_TOKEN)
      end
      subject { @fetcher.fetch_github_token }
      it { is_expected.to eq(VALID_TOKEN) }
    end
  end
end
