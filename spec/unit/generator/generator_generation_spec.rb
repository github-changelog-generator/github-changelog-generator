# frozen_string_literal: true

module GitHubChangelogGenerator
  describe Generator do
    describe "#compound_changelog" do
      it "generates a CHANGELOG file" do
        # mimick parse_options
        options = Parser.default_options

        Parser.fetch_user_and_project(options)

        generator = described_class.new options
        log = generator.compound_changelog
        count = log.scan(GitHubChangelogGenerator::CREDIT_LINE).count

        expect(log).to be_instance_of(String)
        expect(count).to be == 1
      end
    end

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
