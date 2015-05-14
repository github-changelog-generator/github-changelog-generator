describe GitHubChangelogGenerator::Fetcher do
  before(:all) do
    @fetcher = GitHubChangelogGenerator::Fetcher.new
  end

  describe "#fetch_github_token" do
    token = GitHubChangelogGenerator::Fetcher::CHANGELOG_GITHUB_TOKEN
    context "when token in ENV exist" do
      before { stub_const("ENV", ENV.to_hash.merge(token => "0123456789abcdef")) }
      subject { @fetcher.fetch_github_token }
      it { is_expected.to eq("0123456789abcdef") }
    end
    context "when token in ENV is nil" do
      before { stub_const("ENV", ENV.to_hash.merge(token => nil)) }
      subject { @fetcher.fetch_github_token }
      it { is_expected.to be_nil }
    end
  end
end
