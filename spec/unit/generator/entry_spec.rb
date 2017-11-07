# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module GitHubChangelogGenerator
  RSpec.describe Entry do
    def label(name)
      { "name" => name }
    end

    def issue(title, labels, number = "1", user = { "login" => "user" })
      {
        "title" => "issue #{title}",
        "labels" => labels.map { |l| label(l) },
        "number" => number,
        "html_url" => "https://github.com/owner/repo/issue/#{number}",
        "user" => user
      }
    end

    def pr(title, labels, number = "1", user = { "login" => "user" })
      {
        "pull_request" => true,
        "title" => "pr #{title}",
        "labels" => labels.map { |l| label(l) },
        "number" => number,
        "html_url" => "https://github.com/owner/repo/pull/#{number}",
        "user" => user.merge("html_url" => "https://github.com/#{user['login']}")
      }
    end

    def titles_for(issues)
      issues.map { |issue| issue["title"] }
    end

    def default_sections
      %w[enhancements bugs breaking issues]
    end

    describe "#create_entry_for_tag" do
      let(:options) do
        Parser.default_options.merge(
          user: "owner",
          project: "repo",
          bug_labels: ["bug"],
          enhancement_labels: ["enhancement"],
          breaking_labels: ["breaking"]
        )
      end

      let(:issues) do
        [
          issue("no labels", [], "5", "login" => "user1"),
          issue("enhancement", ["enhancement"], "6", "login" => "user2"),
          issue("bug", ["bug"], "7", "login" => "user1"),
          issue("breaking", ["breaking"], "8", "login" => "user5"),
          issue("all the labels", %w[enhancement bug breaking], "9", "login" => "user9")
        ]
      end

      let(:pull_requests) do
        [
          pr("no labels", [], "10", "login" => "user1"),
          pr("enhancement", ["enhancement"], "11", "login" => "user5"),
          pr("bug", ["bug"], "12", "login" => "user5"),
          pr("breaking", ["breaking"], "13", "login" => "user5"),
          pr("all the labels", %w[enhancement bug breaking], "14", "login" => "user5")
        ]
      end

      subject { described_class.new(options) }

      it "generates a header and body" do
        expect(subject.create_entry_for_tag(pull_requests, issues, "1.0.1", "1.0.1", Time.new(2017, 12, 4), "1.0.0")).to eq(<<-CHANGELOG.gsub(/^ {8}/, "")
        ## [1.0.1](https://github.com/owner/repo/tree/1.0.1) (2017-12-04)

        [Full Changelog](https://github.com/owner/repo/compare/1.0.0...1.0.1)

        **Breaking changes:**

        - issue breaking [\\#8](https://github.com/owner/repo/issue/8)
        - pr breaking [\\#13](https://github.com/owner/repo/pull/13) ([user5](https://github.com/user5))

        **Implemented enhancements:**

        - issue enhancement [\\#6](https://github.com/owner/repo/issue/6)
        - issue all the labels [\\#9](https://github.com/owner/repo/issue/9)
        - pr enhancement [\\#11](https://github.com/owner/repo/pull/11) ([user5](https://github.com/user5))
        - pr all the labels [\\#14](https://github.com/owner/repo/pull/14) ([user5](https://github.com/user5))

        **Fixed bugs:**

        - issue bug [\\#7](https://github.com/owner/repo/issue/7)
        - pr bug [\\#12](https://github.com/owner/repo/pull/12) ([user5](https://github.com/user5))

        **Closed issues:**

        - issue no labels [\\#5](https://github.com/owner/repo/issue/5)

        **Merged pull requests:**

        - pr no labels [\\#10](https://github.com/owner/repo/pull/10) ([user1](https://github.com/user1))

      CHANGELOG
                                                                                                                           )
      end
    end
    describe "#parse_sections" do
      before do
        subject { described_class.new }
      end
      context "valid json" do
        let(:sections_string) { "{ \"foo\": { \"prefix\": \"foofix\", \"labels\": [\"test1\", \"test2\"]}, \"bar\": { \"prefix\": \"barfix\", \"labels\": [\"test3\", \"test4\"]}}" }

        let(:sections_array) do
          [
            Section.new(name: "foo", prefix: "foofix", labels: %w[test1 test2]),
            Section.new(name: "bar", prefix: "barfix", labels: %w[test3 test4])
          ]
        end

        it "returns an array with 2 objects" do
          arr = subject.send(:parse_sections, sections_string)
          expect(arr.size).to eq 2
          arr.each { |section| expect(section).to be_an_instance_of Section }
        end

        it "returns correctly constructed sections" do
          require "json"

          sections_json = JSON.parse(sections_string)
          sections_array.each_index do |i|
            aggregate_failures "checks each component" do
              expect(sections_array[i].name).to eq sections_json.first[0]
              expect(sections_array[i].prefix).to eq sections_json.first[1]["prefix"]
              expect(sections_array[i].labels).to eq sections_json.first[1]["labels"]
              expect(sections_array[i].issues).to eq []
            end
            sections_json.shift
          end
        end
      end
      context "hash" do
        let(:sections_hash) do
          {
            enhancements: {
              prefix: "**Enhancements**",
              labels: %w[feature enhancement]
            },
            breaking: {
              prefix: "**Breaking**",
              labels: ["breaking"]
            },
            bugs: {
              prefix: "**Bugs**",
              labels: ["bug"]
            }
          }
        end

        let(:sections_array) do
          [
            Section.new(name: "enhancements", prefix: "**Enhancements**", labels: %w[feature enhancement]),
            Section.new(name: "breaking", prefix: "**Breaking**", labels: ["breaking"]),
            Section.new(name: "bugs", prefix: "**Bugs**", labels: ["bug"])
          ]
        end

        it "returns an array with 3 objects" do
          arr = subject.send(:parse_sections, sections_hash)
          expect(arr.size).to eq 3
          arr.each { |section| expect(section).to be_an_instance_of Section }
        end

        it "returns correctly constructed sections" do
          sections_array.each_index do |i|
            aggregate_failures "checks each component" do
              expect(sections_array[i].name).to eq sections_hash.first[0].to_s
              expect(sections_array[i].prefix).to eq sections_hash.first[1][:prefix]
              expect(sections_array[i].labels).to eq sections_hash.first[1][:labels]
              expect(sections_array[i].issues).to eq []
            end
            sections_hash.shift
          end
        end
      end
    end

    describe "#parse_by_sections" do
      context "default sections" do
        let(:options) do
          {
            bug_labels: ["bug"],
            enhancement_labels: ["enhancement"],
            breaking_labels: ["breaking"]
          }
        end

        let(:issues) do
          [
            issue("no labels", []),
            issue("enhancement", ["enhancement"]),
            issue("bug", ["bug"]),
            issue("breaking", ["breaking"]),
            issue("all the labels", %w[enhancement bug breaking])
          ]
        end

        let(:pull_requests) do
          [
            pr("no labels", []),
            pr("enhancement", ["enhancement"]),
            pr("bug", ["bug"]),
            pr("breaking", ["breaking"]),
            pr("all the labels", %w[enhancement bug breaking])
          ]
        end

        subject { described_class.new(options) }

        before do
          subject.send(:set_sections_and_maps)
          @arr = subject.send(:parse_by_sections, pull_requests, issues)
        end

        it "returns 4 sections" do
          expect(@arr.size).to eq 4
        end

        it "returns default sections" do
          default_sections.each { |default_section| expect(@arr.select { |section| section.name == default_section }.size).to eq 1 }
        end

        it "assigns issues to the correct sections" do
          breaking_section = @arr.select { |section| section.name == "breaking" }[0]
          enhancement_section = @arr.select { |section| section.name == "enhancements" }[0]
          issue_section = @arr.select { |section| section.name == "issues" }[0]
          bug_section = @arr.select { |section| section.name == "bugs" }[0]

          expect(titles_for(breaking_section.issues)).to eq(["issue breaking", "pr breaking"])
          expect(titles_for(enhancement_section.issues)).to eq(["issue enhancement", "issue all the labels", "pr enhancement", "pr all the labels"])
          expect(titles_for(issue_section.issues)).to eq(["issue no labels"])
          expect(titles_for(bug_section.issues)).to eq(["issue bug", "pr bug"])
          expect(titles_for(pull_requests)).to eq(["pr no labels"])
        end
      end
      context "configure sections" do
        let(:options) do
          {
            configure_sections: "{ \"foo\": { \"prefix\": \"foofix\", \"labels\": [\"test1\", \"test2\"]}, \"bar\": { \"prefix\": \"barfix\", \"labels\": [\"test3\", \"test4\"]}}"
          }
        end

        let(:issues) do
          [
            issue("no labels", []),
            issue("test1", ["test1"]),
            issue("test3", ["test3"]),
            issue("test4", ["test4"]),
            issue("all the labels", %w[test1 test2 test3 test4])
          ]
        end

        let(:pull_requests) do
          [
            pr("no labels", []),
            pr("test1", ["test1"]),
            pr("test3", ["test3"]),
            pr("test4", ["test4"]),
            pr("all the labels", %w[test1 test2 test3 test4])
          ]
        end

        subject { described_class.new(options) }

        before do
          subject.send(:set_sections_and_maps)
          @arr = subject.send(:parse_by_sections, pull_requests, issues)
        end

        it "returns 2 sections" do
          expect(@arr.size).to eq 2
        end

        it "returns only configured sections" do
          expect(@arr.select { |section| section.name == "foo" }.size).to eq 1
          expect(@arr.select { |section| section.name == "bar" }.size).to eq 1
        end

        it "assigns issues to the correct sections" do
          foo_section = @arr.select { |section| section.name == "foo" }[0]
          bar_section = @arr.select { |section| section.name == "bar" }[0]

          aggregate_failures "checks all sections" do
            expect(titles_for(foo_section.issues)).to eq(["issue test1", "issue all the labels", "pr test1", "pr all the labels"])
            expect(titles_for(bar_section.issues)).to eq(["issue test3", "issue test4", "pr test3", "pr test4"])
            expect(titles_for(pull_requests)).to eq(["pr no labels"])
          end
        end
      end
      context "add sections" do
        let(:options) do
          {
            bug_labels: ["bug"],
            enhancement_labels: ["enhancement"],
            breaking_labels: ["breaking"],
            add_sections: "{ \"foo\": { \"prefix\": \"foofix\", \"labels\": [\"test1\", \"test2\"]}}"
          }
        end

        let(:issues) do
          [
            issue("no labels", []),
            issue("test1", ["test1"]),
            issue("bugaboo", ["bug"]),
            issue("all the labels", %w[test1 test2 enhancement bug])
          ]
        end

        let(:pull_requests) do
          [
            pr("no labels", []),
            pr("test1", ["test1"]),
            pr("enhance", ["enhancement"]),
            pr("all the labels", %w[test1 test2 enhancement bug])
          ]
        end

        subject { described_class.new(options) }

        before do
          subject.send(:set_sections_and_maps)
          @arr = subject.send(:parse_by_sections, pull_requests, issues)
        end

        it "returns 5 sections" do
          expect(@arr.size).to eq 5
        end

        it "returns default sections" do
          default_sections.each { |default_section| expect(@arr.select { |section| section.name == default_section }.size).to eq 1 }
        end

        it "returns added section" do
          expect(@arr.select { |section| section.name == "foo" }.size).to eq 1
        end

        it "assigns issues to the correct sections" do
          foo_section = @arr.select { |section| section.name == "foo" }[0]
          enhancement_section = @arr.select { |section| section.name == "enhancements" }[0]
          bug_section = @arr.select { |section| section.name == "bugs" }[0]

          aggregate_failures "checks all sections" do
            expect(titles_for(foo_section.issues)).to eq(["issue test1", "issue all the labels", "pr test1", "pr all the labels"])
            expect(titles_for(enhancement_section.issues)).to eq(["pr enhance"])
            expect(titles_for(bug_section.issues)).to eq(["issue bugaboo"])
            expect(titles_for(pull_requests)).to eq(["pr no labels"])
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/ModuleLength
