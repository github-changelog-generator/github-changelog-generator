describe GitHubChangelogGenerator::Generator do
  describe "#get_filtered_tags" do
    before(:all) do
      @generator = GitHubChangelogGenerator::Generator.new
    end

    context "when between_tags nil" do
      subject do
        @generator.instance_variable_set("@options", between_tags: nil)
        @generator.get_filtered_tags(%w(1 2 3))
      end
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(%w(1 2 3)) }
    end

    context "when between_tags same as input array" do
      subject do
        @generator.instance_variable_set("@options", between_tags: %w(1 2 3))
        @generator.get_filtered_tags(%w(1 2 3))
      end
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(%w(1 2 3)) }
    end

    context "when between_tags filled with correct values" do
      subject do
        @generator.instance_variable_set("@options", between_tags: %w(1 2))
        @generator.get_filtered_tags(%w(1 2 3))
      end
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(%w(1 2)) }
    end
    context "when between_tags filled with invalid values" do
      subject do
        @generator.instance_variable_set("@options", between_tags: %w(1 q w))
        @generator.get_filtered_tags(%w(1 2 3))
      end
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(%w(1)) }
    end
  end
end
