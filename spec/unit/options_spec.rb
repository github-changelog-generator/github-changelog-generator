# frozen_string_literal: true
RSpec.describe GitHubChangelogGenerator::Options do
  describe "#initialize" do
    context "with known options" do
      it "instantiates successfully" do
        expect(described_class.new(user: "olle")[:user]).to eq("olle")
      end
    end

    context "with unknown options" do
      it "raises an error" do
        expect do
          described_class.new(
            git_remote: "origin",
            strength: "super-strength",
            wisdom: "deep"
          )
        end.to raise_error("[:strength, :wisdom]")
      end
    end
  end

  describe "#[]=(key, value)" do
    let(:options) { described_class.new(git_remote: "origin") }

    context "with known options" do
      it "sets the option value" do
        expect do
          options[:git_remote] = "in the cloud"
        end.to change { options[:git_remote] }.to "in the cloud"
      end
    end

    context "with unknown options" do
      it "raises an error" do
        expect do
          options[:charisma] = 8
        end.to raise_error(":charisma")
      end
    end
  end
end
