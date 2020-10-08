# frozen_string_literal: true

describe GitHubChangelogGenerator::Parser do
  let(:argv) { [] }

  before do
    # Calling abort will abort the test run, allow calls to abort to not accidentaly get positive falses
    allow(Kernel).to receive(:abort)
  end

  describe ".parse_options" do
    context "when required arguments are given" do
      let(:argv) { ["--user", "the user", "--project", "the_project"] }

      it "executes and prints the configuration" do
        expect { described_class.parse_options(argv) }.to output(/config_file=>".github_changelog_generator"/).to_stdout
      end
    end

    context "when --config-file is overridden to something that is not there" do
      let(:argv) { ["--config-file", "does_not_exist"] }

      it "aborts the execution" do
        expect(Kernel).to receive(:abort)
        expect { described_class.parse_options(argv) }.to output(/Configure which user and project to work on./).to_stderr
      end
    end

    context "when an option with incorrect type is given" do
      let(:argv) { ["--max-issues", "X"] }

      it "aborts the execution with error message from parser" do
        expect(Kernel).to receive(:abort)
        expect { described_class.parse_options(argv) }.to output(/invalid argument: --max-issues X/).to_stderr
      end
    end

    context "when path to configuration file is given" do
      let(:argv) { ["--config-file", File.join(__dir__, "..", "files", "config_example")] }

      it "uses the values from the configuration file" do
        expect { described_class.parse_options(argv) }.to output(/spec_project/).to_stdout
      end
    end

    context "when configuration file and parameters are given" do
      let(:argv) { ["--project", "stronger_project", "--config-file", File.join(__dir__, "..", "files", "config_example")] }

      it "uses the values from the arguments" do
        expect { described_class.parse_options(argv) }.to output(/stronger_project/).to_stdout
      end
    end
  end
end
