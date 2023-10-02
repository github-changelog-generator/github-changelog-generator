# frozen_string_literal: true

require "github_changelog_generator/generator/generator"

RSpec.describe GitHubChangelogGenerator::Generator do
  let(:header) { "# Changelog" }
  let(:generator) { described_class.new({ header: header }) }
  let(:content) do
    <<~'BASE'
      ## [1.3.10](https://github.com/xxx/yyy/tree/1.3.10) (2015-03-18)

      [Full Changelog](https://github.com/xxx/yyy/compare/1.3.9...1.3.10)

      **Fixed bugs:**


    BASE
  end
  let(:footer) do
    <<~CREDIT
      \\* *This Changelog was automatically generated \
      by [github_changelog_generator]\
      (https://github.com/github-changelog-generator/github-changelog-generator)*
    CREDIT
  end

  context "when the given base file has previously appended template messages" do
    describe "#remove_old_fixed_string" do
      it "removes old template headers and footers" do
        log = +"#{header}\n\n#{header}\n#{header}#{content}\n\n#{footer}\n#{footer}#{footer}"

        expect(generator.send(:remove_old_fixed_string, log)).to eq content
      end
    end
  end

  context "when plain contents string was given" do
    describe "#insert_fixed_string" do
      it "append template messages at header and footer" do
        log = String.new(content)
        ans = "#{header}\n\n#{content}\n\n#{footer}"

        expect(generator.send(:insert_fixed_string, log)).to eq ans
      end
    end
  end
end
