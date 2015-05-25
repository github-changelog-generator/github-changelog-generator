describe GitHubChangelogGenerator::Parser do
  describe "#self.user_project_from_remote" do
    context "when remote is 1" do
      subject { GitHubChangelogGenerator::Parser.user_project_from_remote("origin  https://github.com/skywinder/ActionSheetPicker-3.0 (fetch)") }
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(["skywinder", "ActionSheetPicker-3.0"]) }
    end
    context "when remote is 2" do
      subject { GitHubChangelogGenerator::Parser.user_project_from_remote("https://github.com/skywinder/ActionSheetPicker-3.0") }
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(["skywinder", "ActionSheetPicker-3.0"]) }
    end
    context "when remote is 3" do
      subject { GitHubChangelogGenerator::Parser.user_project_from_remote("https://github.com/skywinder/ActionSheetPicker-3.0") }
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(["skywinder", "ActionSheetPicker-3.0"]) }
    end
    context "when remote is 4" do
      subject { GitHubChangelogGenerator::Parser.user_project_from_remote("origin git@github.com:skywinder/ActionSheetPicker-3.0.git (fetch)") }
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(["skywinder", "ActionSheetPicker-3.0"]) }
    end
    context "when remote is invalid" do
      subject { GitHubChangelogGenerator::Parser.user_project_from_remote("some invalid text") }
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array([nil, nil]) }
    end
  end
end
