# frozen_string_literal: true
require "github_changelog_generator/project_name_finder"
RSpec.describe GitHubChangelogGenerator::ProjectNameFinder do
  context "with the empty options" do
    it "finds nothing" do
      expect(described_class.new({}, []).call).to eq [nil, nil]
    end
  end

  describe "#from_git_remote" do
    subject do
      finder = described_class.new({}, [])
      allow(finder).to receive(:git_remote_content) { prepared_content }
      finder.from_git_remote
    end

    context "when remote is type 1" do
      let(:prepared_content) { "origin  https://github.com/skywinder/ActionSheetPicker-3.0 (fetch)" }

      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(["skywinder", "ActionSheetPicker-3.0"]) }
    end

    context "when remote is type 2" do
      let(:prepared_content) { "https://github.com/skywinder/ActionSheetPicker-3.0" }

      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(["skywinder", "ActionSheetPicker-3.0"]) }
    end

    context "when remote is type 3" do
      let(:prepared_content) { "https://github.com/skywinder/ActionSheetPicker-3.0" }

      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(["skywinder", "ActionSheetPicker-3.0"]) }
    end

    context "when remote is type 4" do
      let(:prepared_content) { "origin git@github.com:skywinder/ActionSheetPicker-3.0.git (fetch)" }

      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(["skywinder", "ActionSheetPicker-3.0"]) }
    end

    context "when remote is invalid" do
      let(:prepared_content) { "some invalid text" }

      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array([nil, nil]) }
    end
  end

  describe "#from_cli_option" do
    let(:github_site) { nil }
    subject do
      described_class.new({ github_site: github_site }, [arg1, arg2]).call
    end

    context "when option is invalid" do
      it("should return the empty tuple") { expect(described_class.new({ github_site: nil }, ["blah", nil]).call).to eq [nil, nil] }
    end

    context "when option is valid" do
      let(:arg1) { "skywinder/ActionSheetPicker-3.0" }
      let(:arg2) { nil }

      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(["skywinder", "ActionSheetPicker-3.0"]) }
    end
    context "when option nil" do
      let(:arg1) { nil }
      let(:arg2) { nil }

      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array([nil, nil]) }
    end
    context "when site is nil" do
      let(:arg1) { "skywinder/ActionSheetPicker-3.0" }
      let(:arg2) { nil }

      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(["skywinder", "ActionSheetPicker-3.0"]) }
    end

    context "when site is valid" do
      let(:arg1) { "skywinder/ActionSheetPicker-3.0" }
      let(:arg2) { nil }
      let(:github_site) { "https://codeclimate.com" }

      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(["skywinder", "ActionSheetPicker-3.0"]) }
    end

    context "when second arg is not nil" do
      let(:arg1) { "skywinder/ActionSheetPicker-3.0" }
      let(:arg2) { "blah" }

      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array([nil, nil]) }
    end

    context "when all args is not nil" do
      let(:arg1) { "skywinder/ActionSheetPicker-3.0" }
      let(:arg2) { "blah" }
      let(:github_site) { "https://codeclimate.com" }

      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array([nil, nil]) }
    end
  end
end
