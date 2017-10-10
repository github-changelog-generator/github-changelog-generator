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
            project: "rails",
            strength: "super-strength",
            wisdom: "deep"
          )
        end.to raise_error("[:strength, :wisdom]")
      end
    end
  end

  describe "#[]=(key, value)" do
    let(:options) { described_class.new(project: "rails") }

    context "with known options" do
      it "sets the option value" do
        expect do
          options[:project] = "trails"
        end.to change { options[:project] }.to "trails"
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
