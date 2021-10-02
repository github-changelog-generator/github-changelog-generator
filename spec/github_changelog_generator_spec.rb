# frozen_string_literal: true

describe GitHubChangelogGenerator::ChangelogGenerator do
  describe "#run" do
    let(:arguments) { [] }
    let(:instance)  { described_class.new(arguments) }
    let(:output_path) { File.join(__dir__, "tmp", "test.output") }

    after { FileUtils.rm_rf(output_path) }

    let(:generator) { instance_double(::GitHubChangelogGenerator::Generator) }

    before do
      allow(instance).to receive(:generator) { generator }
      allow(generator).to receive(:compound_changelog) { "content" }
    end

    context "when full path given as the --output argument" do
      let(:arguments) { ["--output", output_path]  }
      it "puts the complete output path to STDOUT" do
        expect { instance.run }.to output(Regexp.new(output_path)).to_stdout
      end
    end

    context "when empty value given as the --output argument" do
      let(:arguments) { ["--output", ""] }
      it "puts the complete output path to STDOUT" do
        expect { instance.run }.to output(/content/).to_stdout
      end
    end
  end
end
