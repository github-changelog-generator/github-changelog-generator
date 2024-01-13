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

  describe "#add_first_occurring_tag_to_prs" do
    def sha(num)
      base = num.to_s
      pad_length = 40 - base.length
      "#{'a' * pad_length}#{base}"
    end

    let(:release_branch_name) { "release" }
    let(:generator) { described_class.new({ release_branch: release_branch_name }) }
    let(:fake_fetcher) do
      instance_double(GitHubChangelogGenerator::OctoFetcher,
                      fetch_tag_shas: nil,
                      fetch_comments_async: nil)
    end

    before do
      allow(fake_fetcher)
        .to receive(:commits_in_branch).with(release_branch_name)
                                       .and_return([sha(1), sha(2), sha(3), sha(4)])
      allow(GitHubChangelogGenerator::OctoFetcher).to receive(:new).and_return(fake_fetcher)
    end

    it "associates prs to the oldest tag containing the merge commit" do
      prs = [{ "events" => [{ "event" => "merged", "commit_id" => sha(2) }] }]
      tags = [
        { "name" => "newer2.0", "shas_in_tag" => [sha(1), sha(2), sha(3)] },
        { "name" => "older1.0", "shas_in_tag" => [sha(1), sha(2)] }
      ]

      prs_left = generator.send(:add_first_occurring_tag_to_prs, tags, prs)

      aggregate_failures do
        expect(prs_left).to be_empty
        expect(prs.first["first_occurring_tag"]).to eq "older1.0"

        expect(fake_fetcher).to have_received(:fetch_tag_shas)
        expect(fake_fetcher).not_to have_received(:fetch_comments_async)
      end
    end

    it "detects prs merged in the release branch" do
      prs = [{ "events" => [{ "event" => "merged", "commit_id" => sha(4) }] }]
      tags = [{ "name" => "v1.0", "shas_in_tag" => [sha(1), sha(2)] }]

      prs_left = generator.send(:add_first_occurring_tag_to_prs, tags, prs)

      aggregate_failures do
        expect(prs_left).to be_empty
        expect(prs.first["first_occurring_tag"]).to be_nil

        expect(fake_fetcher).to have_received(:fetch_tag_shas)
        expect(fake_fetcher).not_to have_received(:fetch_comments_async)
      end
    end

    it "detects closed prs marked as rebased in a tag" do
      prs = [{ "comments" => [{ "body" => "rebased commit: #{sha(2)}" }] }]
      tags = [{ "name" => "v1.0", "shas_in_tag" => [sha(1), sha(2)] }]

      prs_left = generator.send(:add_first_occurring_tag_to_prs, tags, prs)

      aggregate_failures do
        expect(prs_left).to be_empty
        expect(prs.first["first_occurring_tag"]).to eq "v1.0"

        expect(fake_fetcher).to have_received(:fetch_tag_shas)
        expect(fake_fetcher).to have_received(:fetch_comments_async)
      end
    end

    it "detects closed prs marked as rebased in the release branch" do
      prs = [{ "comments" => [{ "body" => "rebased commit: #{sha(4)}" }] }]
      tags = [{ "name" => "v1.0", "shas_in_tag" => [sha(1), sha(2)] }]

      prs_left = generator.send(:add_first_occurring_tag_to_prs, tags, prs)

      aggregate_failures do
        expect(prs_left).to be_empty
        expect(prs.first["first_occurring_tag"]).to be_nil

        expect(fake_fetcher).to have_received(:fetch_tag_shas)
        expect(fake_fetcher).to have_received(:fetch_comments_async)
      end
    end

    it "leaves prs merged in another branch" do
      prs = [{ "events" => [{ "event" => "merged", "commit_id" => sha(5) }] }]
      tags = [{ "name" => "v1.0", "shas_in_tag" => [sha(1), sha(2)] }]

      prs_left = generator.send(:add_first_occurring_tag_to_prs, tags, prs)

      aggregate_failures do
        expect(prs_left).to eq prs
        expect(prs.first["first_occurring_tag"]).to be_nil

        expect(fake_fetcher).to have_received(:fetch_tag_shas)
        expect(fake_fetcher).to have_received(:fetch_comments_async)
      end
    end

    it "raises an error for closed prs marked as rebased to an unknown commit" do
      prs = [{ "number" => "23", "comments" => [{ "body" => "rebased commit: #{sha(5)}" }] }]
      tags = [{ "name" => "v1.0", "shas_in_tag" => [sha(1), sha(2)] }]

      expect { generator.send(:add_first_occurring_tag_to_prs, tags, prs) }
        .to raise_error StandardError, "PR 23 has a rebased SHA comment but that SHA was not found in the release branch or any tags"
    end

    it "raises an error for prs without merge event or rebase comment" do
      prs = [{ "number" => "23" }]
      tags = [{ "name" => "v1.0", "shas_in_tag" => [sha(1), sha(2)] }]

      expect { generator.send(:add_first_occurring_tag_to_prs, tags, prs) }
        .to raise_error StandardError, "No merge sha found for PR 23 via the GitHub API"
    end
  end
end
