# frozen_string_literal: true

module GitHubChangelogGenerator
  describe Generator do
    describe "#get_string_for_issue" do
      let(:issue) do
        { "title" => "Bug in code" }
      end

      it "formats an issue according to options" do
        expect do
          described_class.new.get_string_for_issue(issue)
        end.not_to raise_error
      end
    end
  end
end
