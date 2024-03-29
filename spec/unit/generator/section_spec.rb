# frozen_string_literal: true

module GitHubChangelogGenerator
  RSpec.describe Section do
    let(:options) { {} }
    subject(:section) { described_class.new(options) }

    describe "#encapsulate_string" do
      let(:string) { "" }

      context "with the empty string" do
        it "returns the string" do
          expect(section.send(:encapsulate_string, string)).to eq string
        end
      end

      context "with a string with an escape-needing character in it" do
        let(:string) { "<Inside> and outside" }

        it "returns the string escaped" do
          expect(section.send(:encapsulate_string, string)).to eq '\\<Inside\\> and outside'
        end
      end

      context "with a backticked string with an escape-needing character in it" do
        let(:string) { 'back `\` slash' }

        it "returns the string" do
          expect(section.send(:encapsulate_string, string)).to eq 'back `\` slash'
        end
      end
    end

    describe "#normalize_body" do
      context "it should remove CR" do
        let(:body) { "Some content from GitHub\r\n\r\nUser is describing something" }
        it "returns a cleaned body" do
          expect(section.send(:normalize_body, body)).to eq "Some content from GitHub\n\nUser is describing something"
        end
      end
    end
  end
end
