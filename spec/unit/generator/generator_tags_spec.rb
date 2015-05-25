describe GitHubChangelogGenerator::Generator do
  describe "#get_filtered_tags" do
    before(:all) do
      @generator = GitHubChangelogGenerator::Generator.new
    end

    context "when between_tags nil" do
      # before(:each) do
      #   @generator.options = {}
      # end
      subject { @generator.get_filtered_tags(%w(1 2 3)) }
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(%w(1 2 3)) }
    end

    context "when between_tags 1" do
      # before(:each) do
      #   @generator.options = {between_tags: ["1"]}
      # end

      subject do
        @generator.instance_variable_set("@options", between_tags: ["1"])
        @generator.get_filtered_tags(%w(1 2 3))
      end
      it { is_expected.to be_a(Array) }
      it { is_expected.to match_array(%w(1)) }
    end
  end
end
