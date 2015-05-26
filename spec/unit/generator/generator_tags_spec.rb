describe GitHubChangelogGenerator::Generator do
  describe "#filter_between_tags" do
    context "when between_tags nil" do
      before do
        @generator = GitHubChangelogGenerator::Generator.new(between_tags: nil)
      end

      subject do
        @generator.get_filtered_tags(%w(1 2 3))
      end
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(%w(1 2 3)) }
    end
    context "when between_tags same as input array" do
      before do
        @generator = GitHubChangelogGenerator::Generator.new(between_tags: %w(1 2 3))
      end
      subject do
        @generator.get_filtered_tags(%w(1 2 3))
      end
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(%w(1 2 3)) }
    end

    context "when between_tags filled with correct values" do
      before do
        @generator = GitHubChangelogGenerator::Generator.new(between_tags: %w(1 2))
      end
      subject do
        @generator.get_filtered_tags(%w(1 2 3))
      end
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(%w(1 2)) }
    end

    context "when between_tags filled with invalid values" do
      before do
        @generator = GitHubChangelogGenerator::Generator.new(between_tags: %w(1 q w))
      end

      subject do
        @generator.get_filtered_tags(%w(1 2 3))
      end
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(%w(1)) }
    end
  end

  describe "#get_filtered_tags" do
    subject { generator.get_filtered_tags(%w(1 2 3 4 5)) }
    # before { generator.get_filtered_tags(%w(1 2 3 4 5)) }

    context "with excluded and between tags" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(between_tags: %w(1 2 3), exclude_tags: %w(2)) }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(%w(1 3)) }
    end
  end

  describe "#filter_excluded_tags" do
    subject { generator.filter_excluded_tags(%w(1 2 3)) }

    context "with valid excluded tags" do
      let(:generator) { GitHubChangelogGenerator::Generator.new(exclude_tags: %w(3)) }
      it { is_expected.to be_a Array }
      it { is_expected.to match_array(%w(1 2)) }
    end
  end
end
