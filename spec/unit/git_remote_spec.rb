# frozen_string_literal: true

RSpec.describe GitHubChangelogGenerator::GitRemote do
  describe ".user_and_project" do
    let(:status) { instance_double(Process::Status, success?: success) }
    let(:success) { true }

    before do
      allow(Open3).to receive(:capture2)
        .with("git", "config", "--get-regexp", "^remote\\..*\\.url$")
        .and_return([git_config_output, status])
    end

    context "when origin is configured with an SSH remote" do
      let(:git_config_output) do
        <<~OUTPUT
          remote.upstream.url https://github.com/acme/changelog.git
          remote.origin.url git@github.com:github-changelog-generator/github-changelog-generator.git
        OUTPUT
      end

      it "prefers origin and extracts the owner and repository" do
        expect(described_class.user_and_project).to eq(
          user: "github-changelog-generator",
          project: "github-changelog-generator"
        )
      end
    end

    context "when the remote uses an HTTPS URL" do
      let(:git_config_output) do
        "remote.origin.url https://github.example.com/octo-org/octo-repo.git\n"
      end

      it "extracts the owner and repository from the URL" do
        expect(described_class.user_and_project).to eq(
          user: "octo-org",
          project: "octo-repo"
        )
      end
    end

    context "when git is not available or there are no configured remotes" do
      let(:git_config_output) { "" }
      let(:success) { false }

      it "returns nil" do
        expect(described_class.user_and_project).to be_nil
      end
    end

    context "when git is not installed" do
      let(:git_config_output) { "" }
      let(:success) { false }

      before do
        # Override the shared before block to raise instead
        allow(Open3).to receive(:capture2)
          .with("git", "config", "--get-regexp", "^remote\\..*\\.url$")
          .and_raise(Errno::ENOENT)
      end

      it "returns nil" do
        expect(described_class.user_and_project).to be_nil
      end
    end

    context "when the remote has a path prefix (e.g. GitHub Enterprise)" do
      let(:git_config_output) do
        "remote.origin.url https://ghe.example.com/prefix/octo-org/octo-repo.git\n"
      end

      it "extracts the last two path segments as user and project" do
        expect(described_class.user_and_project).to eq(
          user: "octo-org",
          project: "octo-repo"
        )
      end
    end

    context "when the remote name contains dots" do
      let(:git_config_output) do
        "remote.my.fork.url git@github.com:my-user/my-project.git\n"
      end

      it "correctly parses the remote name and extracts user/project" do
        expect(described_class.user_and_project).to eq(
          user: "my-user",
          project: "my-project"
        )
      end
    end
  end
end
