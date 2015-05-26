describe GitHubChangelogGenerator::Generator do
  describe "#get_filtered_tags" do
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
end
