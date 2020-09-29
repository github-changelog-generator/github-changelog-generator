# frozen_string_literal: true

module GitHubChangelogGenerator
  RSpec.describe Entry do
    def label(name)
      { "name" => name }
    end

    def issue(title, labels, body = "", number = "1", user = { "login" => "user" })
      {
        "title" => "issue #{title}",
        "labels" => labels.map { |l| label(l) },
        "number" => number,
        "html_url" => "https://github.com/owner/repo/issue/#{number}",
        "user" => user,
        "body" => body,
        "events" => [{
          "event" => "closed"
        }]
      }
    end

    def pr(title, labels, body = "", number = "1", user = { "login" => "user" })
      {
        "pull_request" => true,
        "title" => "pr #{title}",
        "labels" => labels.map { |l| label(l) },
        "number" => number,
        "html_url" => "https://github.com/owner/repo/pull/#{number}",
        "user" => user.merge("html_url" => "https://github.com/#{user['login']}"),
        "body" => body,
        "merged_at" => Time.now.utc,
        "events" => [{
          "event" => "merged",
          "commit_id" => "aaaaa#{number}"
        }]
      }
    end

    def tag(name, sha, shas_in_tag)
      {
        "name" => name,
        "commit" => { "sha" => sha },
        "shas_in_tag" => shas_in_tag
      }
    end

    def titles_for(issues)
      issues.map { |issue| issue["title"] }
    end

    def default_sections
      %w[breaking enhancements bugs deprecated removed security issues]
    end

    # Default to no issues, PRs, or tags.
    let(:issues) { [] }
    let(:pull_requests) { [] }
    let(:tags) { [] }

    # Default to standard options minus verbose to avoid output during testing.
    let(:options) do
      Parser.default_options.merge(verbose: false)
    end

    # Mock out fake github fetching for the issues/pull_requests lets and then
    # expose filtering from the GitHubChangelogGenerator::Generator class
    # instance for end-to-end entry testing.
    let(:generator) do
      fake_fetcher = instance_double(
        "fetcher",
        fetch_closed_issues_and_pr: [issues, pull_requests],
        fetch_closed_pull_requests: [],
        fetch_events_async: issues + pull_requests,
        fetch_tag_shas: nil,
        fetch_comments_async: nil,
        default_branch: "master",
        oldest_commit: { "sha" => "aaaaa1" },
        fetch_commit: { "commit" => { "author" => { "date" => Time.now.utc } } }
      )
      allow(fake_fetcher).to receive(:commits_in_branch) do
        ["aaaaa1"]
      end
      allow(GitHubChangelogGenerator::OctoFetcher).to receive(:new).and_return(fake_fetcher)
      generator = GitHubChangelogGenerator::Generator.new(options)
      generator.instance_variable_set :@sorted_tags, tags
      generator.send(:fetch_issues_and_pr)
      generator
    end
    let(:filtered_issues) do
      generator.instance_variable_get :@issues
    end
    let(:filtered_pull_requests) do
      generator.instance_variable_get :@pull_requests
    end
    let(:entry_sections) do
      subject.send(:create_sections)
      # In normal usage, the entry generation would have received filtered
      # issues and pull requests so replicate that here for ease of testing.
      subject.send(:sort_into_sections, filtered_pull_requests, filtered_issues)
      subject.instance_variable_get :@sections
    end

    describe "#generate_entry_for_tag" do
      let(:issues) do
        [
          issue("no labels", [], "", "5", "login" => "user1"),
          issue("breaking", ["breaking"], "", "8", "login" => "user5"),
          issue("enhancement", ["enhancement"], "", "6", "login" => "user2"),
          issue("bug", ["bug"], "", "7", "login" => "user1"),
          issue("deprecated", ["deprecated"], "", "13", "login" => "user5"),
          issue("removed", ["removed"], "", "14", "login" => "user2"),
          issue("security", ["security"], "", "15", "login" => "user5"),
          issue("all the labels", %w[breaking enhancement bug deprecated removed security], "", "9", "login" => "user9"),
          issue("all the labels different order", %w[bug breaking enhancement security removed deprecated], "", "10", "login" => "user5"),
          issue("some unmapped labels", %w[tests-fail bug], "", "11", "login" => "user5"),
          issue("no mapped labels", %w[docs maintenance], "", "12", "login" => "user5")
        ]
      end

      let(:pull_requests) do
        [
          pr("no labels", [], "",  "20", "login" => "user1"),
          pr("breaking", ["breaking"], "", "23", "login" => "user5"),
          pr("enhancement", ["enhancement"], "",  "21", "login" => "user5"),
          pr("bug", ["bug"], "", "22", "login" => "user5"),
          pr("deprecated", ["deprecated"], "", "28", "login" => "user5"),
          pr("removed", ["removed"], "", "29", "login" => "user2"),
          pr("security", ["security"], "", "30", "login" => "user5"),
          pr("all the labels", %w[breaking enhancement bug deprecated removed security], "", "24", "login" => "user5"),
          pr("all the labels different order", %w[bug breaking enhancement security remove deprecated], "", "25", "login" => "user5"),
          pr("some unmapped labels", %w[tests-fail bug], "",  "26", "login" => "user5"),
          pr("no mapped labels", %w[docs maintenance], "", "27", "login" => "user5")
        ]
      end

      let(:tags) do
        [tag("1.0.0", "aaaaa30", (1..30).collect { |i| "aaaaa#{i}" })]
      end

      subject { described_class.new(options) }
      describe "include issues without labels" do
        let(:options) do
          Parser.default_options.merge(
            user: "owner",
            project: "repo",
            breaking_labels: ["breaking"],
            enhancement_labels: ["enhancement"],
            bug_labels: ["bug"],
            deprecated_labels: ["deprecated"],
            removed_labels: ["removed"],
            security_labels: ["security"],
            verbose: false
          )
        end

        it "generates a header and body" do
          changelog = <<-CHANGELOG.gsub(/^ {10}/, "")
          ## [1.0.1](https://github.com/owner/repo/tree/1.0.1) (2017-12-04)

          [Full Changelog](https://github.com/owner/repo/compare/1.0.0...1.0.1)

          **Breaking changes:**

          - issue breaking [\\#8](https://github.com/owner/repo/issue/8)
          - issue all the labels [\\#9](https://github.com/owner/repo/issue/9)
          - issue all the labels different order [\\#10](https://github.com/owner/repo/issue/10)
          - pr breaking [\\#23](https://github.com/owner/repo/pull/23) ([user5](https://github.com/user5))
          - pr all the labels [\\#24](https://github.com/owner/repo/pull/24) ([user5](https://github.com/user5))
          - pr all the labels different order [\\#25](https://github.com/owner/repo/pull/25) ([user5](https://github.com/user5))

          **Implemented enhancements:**

          - issue enhancement [\\#6](https://github.com/owner/repo/issue/6)
          - pr enhancement [\\#21](https://github.com/owner/repo/pull/21) ([user5](https://github.com/user5))

          **Fixed bugs:**

          - issue bug [\\#7](https://github.com/owner/repo/issue/7)
          - issue some unmapped labels [\\#11](https://github.com/owner/repo/issue/11)
          - pr bug [\\#22](https://github.com/owner/repo/pull/22) ([user5](https://github.com/user5))
          - pr some unmapped labels [\\#26](https://github.com/owner/repo/pull/26) ([user5](https://github.com/user5))

          **Deprecated:**

          - issue deprecated [\\#13](https://github.com/owner/repo/issue/13)
          - pr deprecated [\\#28](https://github.com/owner/repo/pull/28) ([user5](https://github.com/user5))

          **Removed:**

          - issue removed [\\#14](https://github.com/owner/repo/issue/14)
          - pr removed [\\#29](https://github.com/owner/repo/pull/29) ([user2](https://github.com/user2))

          **Security fixes:**

          - issue security [\\#15](https://github.com/owner/repo/issue/15)
          - pr security [\\#30](https://github.com/owner/repo/pull/30) ([user5](https://github.com/user5))

          **Closed issues:**

          - issue no labels [\\#5](https://github.com/owner/repo/issue/5)
          - issue no mapped labels [\\#12](https://github.com/owner/repo/issue/12)

          **Merged pull requests:**

          - pr no labels [\\#20](https://github.com/owner/repo/pull/20) ([user1](https://github.com/user1))
          - pr no mapped labels [\\#27](https://github.com/owner/repo/pull/27) ([user5](https://github.com/user5))

          CHANGELOG

          expect(subject.generate_entry_for_tag(pull_requests, issues, "1.0.1", "1.0.1", Time.new(2017, 12, 4, 12, 0, 0, "+00:00").utc, "1.0.0")).to eq(changelog)
        end
      end

      describe "#create_entry_for_tag_with_body" do
        let(:options) do
          Parser.default_options.merge(
            user: "owner",
            project: "repo",
            bug_labels: ["bug"],
            enhancement_labels: ["enhancement"],
            breaking_labels: ["breaking"],
            issue_line_body: true
          )
        end

        let(:issues_with_body) do
          [
            issue("no labels", [], "Issue body description", "5", "login" => "user1"),
            issue("breaking", ["breaking"], "Issue body description very long: Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim.", "8", "login" => "user5"),
            issue("enhancement", ["enhancement"], "Issue body description", "6", "login" => "user2"),
            issue("bug", ["bug"], "Issue body description", "7", "login" => "user1"),
            issue("deprecated", ["deprecated"], "Issue body description", "13", "login" => "user5"),
            issue("removed", ["removed"], "Issue body description", "14", "login" => "user2"),
            issue("security", ["security"], "Issue body description", "15", "login" => "user5"),
            issue("all the labels", %w[breaking enhancement bug deprecated removed security], "Issue body description. \nThis part should not appear.", "9", "login" => "user9"),
            issue("all the labels different order", %w[bug breaking enhancement security removed deprecated], "Issue body description", "10", "login" => "user5"),
            issue("some unmapped labels", %w[tests-fail bug], "Issue body description", "11", "login" => "user5"),
            issue("no mapped labels", %w[docs maintenance], "Issue body description", "12", "login" => "user5")
          ]
        end

        let(:pull_requests_with_body) do
          [
            pr("no labels", [], "PR body description", "20", "login" => "user1"),
            pr("breaking", ["breaking"], "PR body description very long: Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim.", "23", "login" => "user5"),
            pr("enhancement", ["enhancement"], "PR body description", "21", "login" => "user5"),
            pr("bug", ["bug"], "PR body description", "22", "login" => "user5"),
            pr("deprecated", ["deprecated"], "PR body description", "28", "login" => "user5"),
            pr("removed", ["removed"], "PR body description", "29", "login" => "user2"),
            pr("security", ["security"], "PR body description", "30", "login" => "user5"),
            pr("all the labels", %w[breaking enhancement bug deprecated removed security], "PR body description. \nThis part should not appear", "24", "login" => "user5"),
            pr("all the labels different order", %w[bug breaking enhancement security remove deprecated], "PR body description", "25", "login" => "user5"),
            pr("some unmapped labels", %w[tests-fail bug], "PR body description", "26", "login" => "user5"),
            pr("no mapped labels", %w[docs maintenance], "PR body description", "27", "login" => "user5")
          ]
        end

        subject { described_class.new(options) }
        it "generates issues and pull requests with body" do
          changelog = <<-CHANGELOG.gsub(/^ {10}/, "")
          ## [1.0.1](https://github.com/owner/repo/tree/1.0.1) (2017-12-04)

          [Full Changelog](https://github.com/owner/repo/compare/1.0.0...1.0.1)

          **Breaking changes:**

          - **issue breaking [\\#8](https://github.com/owner/repo/issue/8)**   \nIssue body description very long: Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim.
          - **issue all the labels [\\#9](https://github.com/owner/repo/issue/9)**   \nIssue body description.
          - **issue all the labels different order [\\#10](https://github.com/owner/repo/issue/10)**   \nIssue body description
          - **pr breaking [\\#23](https://github.com/owner/repo/pull/23) ([user5](https://github.com/user5))**   \nPR body description very long: Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim.
          - **pr all the labels [\\#24](https://github.com/owner/repo/pull/24) ([user5](https://github.com/user5))**   \nPR body description.
          - **pr all the labels different order [\\#25](https://github.com/owner/repo/pull/25) ([user5](https://github.com/user5))**   \nPR body description

          **Implemented enhancements:**

          - **issue enhancement [\\#6](https://github.com/owner/repo/issue/6)**   \nIssue body description
          - **pr enhancement [\\#21](https://github.com/owner/repo/pull/21) ([user5](https://github.com/user5))**   \nPR body description

          **Fixed bugs:**

          - **issue bug [\\#7](https://github.com/owner/repo/issue/7)**   \nIssue body description
          - **issue some unmapped labels [\\#11](https://github.com/owner/repo/issue/11)**   \nIssue body description
          - **pr bug [\\#22](https://github.com/owner/repo/pull/22) ([user5](https://github.com/user5))**   \nPR body description
          - **pr some unmapped labels [\\#26](https://github.com/owner/repo/pull/26) ([user5](https://github.com/user5))**   \nPR body description

          **Deprecated:**

          - **issue deprecated [\\#13](https://github.com/owner/repo/issue/13)**   \nIssue body description
          - **pr deprecated [\\#28](https://github.com/owner/repo/pull/28) ([user5](https://github.com/user5))**   \nPR body description

          **Removed:**

          - **issue removed [\\#14](https://github.com/owner/repo/issue/14)**   \nIssue body description
          - **pr removed [\\#29](https://github.com/owner/repo/pull/29) ([user2](https://github.com/user2))**   \nPR body description

          **Security fixes:**

          - **issue security [\\#15](https://github.com/owner/repo/issue/15)**   \nIssue body description
          - **pr security [\\#30](https://github.com/owner/repo/pull/30) ([user5](https://github.com/user5))**   \nPR body description

          **Closed issues:**

          - **issue no labels [\\#5](https://github.com/owner/repo/issue/5)**   \nIssue body description
          - **issue no mapped labels [\\#12](https://github.com/owner/repo/issue/12)**   \nIssue body description

          **Merged pull requests:**

          - **pr no labels [\\#20](https://github.com/owner/repo/pull/20) ([user1](https://github.com/user1))**   \nPR body description
          - **pr no mapped labels [\\#27](https://github.com/owner/repo/pull/27) ([user5](https://github.com/user5))**   \nPR body description

          CHANGELOG
          expect(subject.generate_entry_for_tag(pull_requests_with_body, issues_with_body, "1.0.1", "1.0.1", Time.new(2017, 12, 4, 12, 0, 0, "+00:00").utc, "1.0.0")).to eq(changelog)
        end
      end

      describe "exclude issues without labels" do
        let(:options) do
          Parser.default_options.merge(
            user: "owner",
            project: "repo",
            breaking_labels: ["breaking"],
            enhancement_labels: ["enhancement"],
            bug_labels: ["bug"],
            deprecated_labels: ["deprecated"],
            removed_labels: ["removed"],
            security_labels: ["security"],
            add_pr_wo_labels: false,
            add_issues_wo_labels: false,
            verbose: false
          )
        end

        it "generates a header and body" do
          changelog = <<-CHANGELOG.gsub(/^ {10}/, "")
          ## [1.0.1](https://github.com/owner/repo/tree/1.0.1) (2017-12-04)

          [Full Changelog](https://github.com/owner/repo/compare/1.0.0...1.0.1)

          **Breaking changes:**

          - issue breaking [\\#8](https://github.com/owner/repo/issue/8)
          - issue all the labels [\\#9](https://github.com/owner/repo/issue/9)
          - issue all the labels different order [\\#10](https://github.com/owner/repo/issue/10)
          - pr breaking [\\#23](https://github.com/owner/repo/pull/23) ([user5](https://github.com/user5))
          - pr all the labels [\\#24](https://github.com/owner/repo/pull/24) ([user5](https://github.com/user5))
          - pr all the labels different order [\\#25](https://github.com/owner/repo/pull/25) ([user5](https://github.com/user5))

          **Implemented enhancements:**

          - issue enhancement [\\#6](https://github.com/owner/repo/issue/6)
          - pr enhancement [\\#21](https://github.com/owner/repo/pull/21) ([user5](https://github.com/user5))

          **Fixed bugs:**

          - issue bug [\\#7](https://github.com/owner/repo/issue/7)
          - issue some unmapped labels [\\#11](https://github.com/owner/repo/issue/11)
          - pr bug [\\#22](https://github.com/owner/repo/pull/22) ([user5](https://github.com/user5))
          - pr some unmapped labels [\\#26](https://github.com/owner/repo/pull/26) ([user5](https://github.com/user5))

          **Deprecated:**

          - issue deprecated [\\#13](https://github.com/owner/repo/issue/13)
          - pr deprecated [\\#28](https://github.com/owner/repo/pull/28) ([user5](https://github.com/user5))

          **Removed:**

          - issue removed [\\#14](https://github.com/owner/repo/issue/14)
          - pr removed [\\#29](https://github.com/owner/repo/pull/29) ([user2](https://github.com/user2))

          **Security fixes:**

          - issue security [\\#15](https://github.com/owner/repo/issue/15)
          - pr security [\\#30](https://github.com/owner/repo/pull/30) ([user5](https://github.com/user5))

          **Closed issues:**

          - issue no mapped labels [\\#12](https://github.com/owner/repo/issue/12)

          **Merged pull requests:**

          - pr no mapped labels [\\#27](https://github.com/owner/repo/pull/27) ([user5](https://github.com/user5))

          CHANGELOG

          expect(subject.generate_entry_for_tag(pull_requests, issues, "1.0.1", "1.0.1", Time.new(2017, 12, 4, 12, 0, 0, "+00:00").utc, "1.0.0")).to eq(changelog)
        end
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
        context "parse also body_only" do
          let(:sections_string) { "{ \"foo\": { \"prefix\": \"foofix\", \"labels\": [\"test1\", \"test2\"]}, \"bar\": { \"prefix\": \"barfix\", \"labels\": [\"test3\", \"test4\"], \"body_only\": true}}" }

          it "returns correctly constructed sections" do
            require "json"

            parsed_sections = subject.send(:parse_sections, sections_string)

            expect(parsed_sections[0].body_only).to eq false
            expect(parsed_sections[1].body_only).to eq true
          end
        end
      end
      context "hash" do
        let(:sections_hash) do
          {
            breaking: {
              prefix: "**Breaking**",
              labels: ["breaking"]
            },
            enhancements: {
              prefix: "**Enhancements**",
              labels: %w[feature enhancement]
            },
            bugs: {
              prefix: "**Bugs**",
              labels: ["bug"]
            },
            deprecated: {
              prefix: "**Deprecated**",
              labels: ["deprecated"]
            },
            removed: {
              prefix: "**Removed**",
              labels: ["removed"]
            },
            security: {
              prefix: "**Security**",
              labels: ["security"]
            }
          }
        end

        let(:sections_array) do
          [
            Section.new(name: "breaking", prefix: "**Breaking**", labels: ["breaking"]),
            Section.new(name: "enhancements", prefix: "**Enhancements**", labels: %w[feature enhancement]),
            Section.new(name: "bugs", prefix: "**Bugs**", labels: ["bug"]),
            Section.new(name: "deprecated", prefix: "**Deprecated**", labels: ["deprecated"]),
            Section.new(name: "removed", prefix: "**Removed**", labels: ["removed"]),
            Section.new(name: "security", prefix: "**Security**", labels: ["security"])
          ]
        end

        it "returns an array with 6 objects" do
          arr = subject.send(:parse_sections, sections_hash)
          expect(arr.size).to eq 6
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

    describe "#sort_into_sections" do
      context "default sections" do
        let(:options) do
          Parser.default_options.merge(
            breaking_labels: ["breaking"],
            enhancement_labels: ["enhancement"],
            bug_labels: ["bug"],
            deprecated_labels: ["deprecated"],
            removed_labels: ["removed"],
            security_labels: ["security"],
            verbose: false
          )
        end

        let(:issues) do
          [
            issue("breaking", ["breaking"]),
            issue("no labels", []),
            issue("enhancement", ["enhancement"]),
            issue("bug", ["bug"]),
            issue("deprecated", ["deprecated"]),
            issue("removed", ["removed"]),
            issue("security", ["security"]),
            issue("all the labels", %w[breaking enhancement bug deprecated removed security]),
            issue("some unmapped labels", %w[tests-fail bug]),
            issue("no mapped labels", %w[docs maintenance]),
            issue("excluded label", %w[wontfix]),
            issue("excluded and included label", %w[breaking wontfix])
          ]
        end

        let(:pull_requests) do
          [
            pr("no labels", []),
            pr("breaking", ["breaking"]),
            pr("enhancement", ["enhancement"]),
            pr("bug", ["bug"]),
            pr("deprecated", ["deprecated"]),
            pr("removed", ["removed"]),
            pr("security", ["security"]),
            pr("all the labels", %w[breaking enhancement bug deprecated removed security]),
            pr("some unmapped labels", %w[tests-fail bug]),
            pr("no mapped labels", %w[docs maintenance]),
            pr("excluded label", %w[wontfix]),
            pr("excluded and included label", %w[breaking wontfix])
          ]
        end

        subject { described_class.new(options) }

        it "returns 9 sections" do
          entry_sections.each { |sec| pp(sec.name) }
          expect(entry_sections.size).to eq 9
        end

        it "returns default sections" do
          default_sections.each { |default_section| expect(entry_sections.count { |section| section.name == default_section }).to eq 1 }
        end

        it "assigns issues to the correct sections" do
          breaking_section = entry_sections.find { |section| section.name == "breaking" }
          enhancement_section = entry_sections.find { |section| section.name == "enhancements" }
          bug_section = entry_sections.find { |section| section.name == "bugs" }
          deprecated_section = entry_sections.find { |section| section.name == "deprecated" }
          removed_section = entry_sections.find { |section| section.name == "removed" }
          security_section = entry_sections.find { |section| section.name == "security" }
          issue_section = entry_sections.find { |section| section.name == "issues" }
          merged_section = entry_sections.find { |section| section.name == "merged" }

          expect(titles_for(breaking_section.issues)).to eq(["issue breaking", "issue all the labels", "pr breaking", "pr all the labels"])
          expect(titles_for(enhancement_section.issues)).to eq(["issue enhancement", "pr enhancement"])
          expect(titles_for(bug_section.issues)).to eq(["issue bug", "issue some unmapped labels", "pr bug", "pr some unmapped labels"])
          expect(titles_for(deprecated_section.issues)).to eq(["issue deprecated", "pr deprecated"])
          expect(titles_for(removed_section.issues)).to eq(["issue removed", "pr removed"])
          expect(titles_for(security_section.issues)).to eq(["issue security", "pr security"])
          expect(titles_for(issue_section.issues)).to eq(["issue no labels", "issue no mapped labels"])
          expect(titles_for(merged_section.issues)).to eq(["pr no labels", "pr no mapped labels"])
        end
      end
      context "configure sections and include labels" do
        let(:options) do
          Parser.default_options.merge(
            configure_sections: "{ \"foo\": { \"prefix\": \"foofix\", \"labels\": [\"test1\", \"test2\"]}, \"bar\": { \"prefix\": \"barfix\", \"labels\": [\"test3\", \"test4\"]}}",
            include_labels: %w[test1 test2 test3 test4],
            verbose: false
          )
        end

        let(:issues) do
          [
            issue("no labels", []),
            issue("test1", ["test1"]),
            issue("test3", ["test3"]),
            issue("test4", ["test4"]),
            issue("all the labels", %w[test4 test2 test3 test1]),
            issue("some included labels", %w[unincluded test2]),
            issue("no included labels", %w[unincluded again])
          ]
        end

        let(:pull_requests) do
          [
            pr("no labels", []),
            pr("test1", ["test1"]),
            pr("test3", ["test3"]),
            pr("test4", ["test4"]),
            pr("all the labels", %w[test4 test2 test3 test1]),
            pr("some included labels", %w[unincluded test2]),
            pr("no included labels", %w[unincluded again])
          ]
        end

        subject { described_class.new(options) }

        it "returns 4 sections" do
          expect(entry_sections.size).to eq 4
        end

        it "returns only configured sections" do
          expect(entry_sections.count { |section| section.name == "foo" }).to eq 1
          expect(entry_sections.count { |section| section.name == "bar" }).to eq 1
        end

        it "assigns issues to the correct sections" do
          foo_section = entry_sections.find { |section| section.name == "foo" }
          bar_section = entry_sections.find { |section| section.name == "bar" }
          issue_section = entry_sections.find { |section| section.name == "issues" }
          merged_section = entry_sections.find { |section| section.name == "merged" }

          aggregate_failures "checks all sections" do
            expect(titles_for(foo_section.issues)).to eq(["issue test1", "issue all the labels", "issue some included labels", "pr test1", "pr all the labels", "pr some included labels"])
            expect(titles_for(bar_section.issues)).to eq(["issue test3", "issue test4", "pr test3", "pr test4"])
            expect(titles_for(merged_section.issues)).to eq(["pr no labels"])
            expect(titles_for(issue_section.issues)).to eq(["issue no labels"])
          end
        end
      end
      context "configure sections and exclude labels" do
        let(:options) do
          Parser.default_options.merge(
            configure_sections: "{ \"foo\": { \"prefix\": \"foofix\", \"labels\": [\"test1\", \"test2\"]}, \"bar\": { \"prefix\": \"barfix\", \"labels\": [\"test3\", \"test4\"]}}",
            exclude_labels: ["excluded"],
            verbose: false
          )
        end

        let(:issues) do
          [
            issue("no labels", []),
            issue("test1", ["test1"]),
            issue("test3", ["test3"]),
            issue("test4", ["test4"]),
            issue("all the labels", %w[test4 test2 test3 test1]),
            issue("some excluded labels", %w[excluded test2]),
            issue("excluded labels", %w[excluded again])
          ]
        end

        let(:pull_requests) do
          [
            pr("no labels", []),
            pr("test1", ["test1"]),
            pr("test3", ["test3"]),
            pr("test4", ["test4"]),
            pr("all the labels", %w[test4 test2 test3 test1]),
            pr("some excluded labels", %w[excluded test2]),
            pr("excluded labels", %w[excluded again])
          ]
        end

        subject { described_class.new(options) }

        it "returns 4 sections" do
          expect(entry_sections.size).to eq 4
        end

        it "returns only configured sections" do
          expect(entry_sections.count { |section| section.name == "foo" }).to eq 1
          expect(entry_sections.count { |section| section.name == "bar" }).to eq 1
        end

        it "assigns issues to the correct sections" do
          foo_section = entry_sections.find { |section| section.name == "foo" }
          bar_section = entry_sections.find { |section| section.name == "bar" }
          issue_section = entry_sections.find { |section| section.name == "issues" }
          merged_section = entry_sections.find { |section| section.name == "merged" }

          aggregate_failures "checks all sections" do
            expect(titles_for(foo_section.issues)).to eq(["issue test1", "issue all the labels", "pr test1", "pr all the labels"])
            expect(titles_for(bar_section.issues)).to eq(["issue test3", "issue test4", "pr test3", "pr test4"])
            expect(titles_for(merged_section.issues)).to eq(["pr no labels"])
            expect(titles_for(issue_section.issues)).to eq(["issue no labels"])
          end
        end
      end
      context "add sections" do
        let(:options) do
          Parser.default_options.merge(
            breaking_labels: ["breaking"],
            enhancement_labels: ["enhancement"],
            bug_labels: ["bug"],
            deprecated_labels: ["deprecated"],
            removed_labels: ["removed"],
            security_labels: ["security"],
            add_sections: "{ \"foo\": { \"prefix\": \"foofix\", \"labels\": [\"test1\", \"test2\"]}}",
            verbose: false
          )
        end

        let(:issues) do
          [
            issue("no labels", []),
            issue("test1", ["test1"]),
            issue("bugaboo", ["bug"]),
            issue("all the labels", %w[test1 test2 breaking enhancement bug deprecated removed security]),
            issue("default labels first", %w[enhancement bug test1 test2]),
            issue("some excluded labels", %w[wontfix breaking]),
            issue("excluded labels", %w[wontfix again])
          ]
        end

        let(:pull_requests) do
          [
            pr("no labels", []),
            pr("test1", ["test1"]),
            pr("enhance", ["enhancement"]),
            pr("all the labels", %w[test1 test2 breaking enhancement bug deprecated removed security]),
            pr("default labels first", %w[enhancement bug test1 test2]),
            pr("some excluded labels", %w[wontfix breaking]),
            pr("excluded labels", %w[wontfix again])
          ]
        end

        subject { described_class.new(options) }

        it "returns 10 sections" do
          entry_sections.each { |sec| pp(sec.name) }
          expect(entry_sections.size).to eq 10
        end

        it "returns default sections" do
          default_sections.each { |default_section| expect(entry_sections.count { |section| section.name == default_section }).to eq 1 }
        end

        it "returns added section" do
          expect(entry_sections.count { |section| section.name == "foo" }).to eq 1
        end

        it "assigns issues to the correct sections" do
          foo_section = entry_sections.find { |section| section.name == "foo" }
          breaking_section = entry_sections.find { |section| section.name == "breaking" }
          enhancement_section = entry_sections.find { |section| section.name == "enhancements" }
          bug_section = entry_sections.find { |section| section.name == "bugs" }
          issue_section = entry_sections.find { |section| section.name == "issues" }
          merged_section = entry_sections.find { |section| section.name == "merged" }

          aggregate_failures "checks all sections" do
            expect(titles_for(breaking_section.issues)).to eq(["issue all the labels", "pr all the labels"])
            expect(titles_for(enhancement_section.issues)).to eq(["issue default labels first", "pr enhance", "pr default labels first"])
            expect(titles_for(bug_section.issues)).to eq(["issue bugaboo"])
            expect(titles_for(foo_section.issues)).to eq(["issue test1", "pr test1"])
            expect(titles_for(issue_section.issues)).to eq(["issue no labels"])
            expect(titles_for(merged_section.issues)).to eq(["pr no labels"])
          end
        end
      end
    end
  end
end
