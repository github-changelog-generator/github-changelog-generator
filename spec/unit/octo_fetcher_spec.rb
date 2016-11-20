# frozen_string_literal: true
VALID_TOKEN = "0123456789abcdef"
INVALID_TOKEN = "0000000000000000"

describe GitHubChangelogGenerator::OctoFetcher do
  let(:options) do
    {
      user: "skywinder",
      project: "changelog_test"
    }
  end

  let(:fetcher) { GitHubChangelogGenerator::OctoFetcher.new(options) }

  describe "#check_github_response" do
    context "when returns successfully" do
      it "returns block value" do
        expect(fetcher.send(:check_github_response) { 1 + 1 }).to eq(2)
      end
    end

    context "when raises Octokit::Unauthorized" do
      it "aborts" do
        expect(fetcher).to receive(:sys_abort).with("Error: wrong GitHub token")
        fetcher.send(:check_github_response) { raise(Octokit::Unauthorized) }
      end
    end

    context "when raises Octokit::Forbidden" do
      it "sleeps and retries and then aborts" do
        retry_limit = GitHubChangelogGenerator::OctoFetcher::MAX_FORBIDDEN_RETRIES - 1
        allow(fetcher).to receive(:sleep_base_interval).exactly(retry_limit).times.and_return(0)

        expect(fetcher).to receive(:sys_abort).with("Exceeded retry limit")
        fetcher.send(:check_github_response) { raise(Octokit::Forbidden) }
      end
    end
  end

  describe "#fetch_github_token" do
    token = GitHubChangelogGenerator::OctoFetcher::CHANGELOG_GITHUB_TOKEN
    context "when token in ENV exist" do
      before { stub_const("ENV", ENV.to_hash.merge(token => VALID_TOKEN)) }
      subject { fetcher.send(:fetch_github_token) }
      it { is_expected.to eq(VALID_TOKEN) }
    end

    context "when token in ENV is nil" do
      before { stub_const("ENV", ENV.to_hash.merge(token => nil)) }
      subject { fetcher.send(:fetch_github_token) }
      it { is_expected.to be_nil }
    end

    context "when token in options and ENV is nil" do
      let(:options) { { token: VALID_TOKEN } }

      before do
        stub_const("ENV", ENV.to_hash.merge(token => nil))
      end

      subject { fetcher.send(:fetch_github_token) }
      it { is_expected.to eq(VALID_TOKEN) }
    end

    context "when token in options and ENV specified" do
      let(:options) { { token: VALID_TOKEN } }

      before do
        stub_const("ENV", ENV.to_hash.merge(token => "no_matter_what"))
      end

      subject { fetcher.send(:fetch_github_token) }
      it { is_expected.to eq(VALID_TOKEN) }
    end
  end

  describe "#get_all_tags" do
    context "when github_fetch_tags returns tags" do
      it "returns tags" do
        mock_tags = ["tag"]
        allow(fetcher).to receive(:github_fetch_tags).and_return(mock_tags)
        expect(fetcher.get_all_tags).to eq(mock_tags)
      end
    end
  end

  describe "#github_fetch_tags" do
    context "when wrong token provided", :vcr do
      let(:options) do
        {
          user: "skywinder",
          project: "changelog_test",
          token: INVALID_TOKEN
        }
      end

      it "should raise Unauthorized error" do
        expect { fetcher.github_fetch_tags }.to raise_error SystemExit, "Error: wrong GitHub token"
      end
    end

    context "when API call is valid", :vcr do
      it "should return tags" do
        expected_tags = [{ "name"        => "v0.0.3",
                           "zipball_url" =>
                             "https://api.github.com/repos/skywinder/changelog_test/zipball/v0.0.3",
                           "tarball_url" =>
                             "https://api.github.com/repos/skywinder/changelog_test/tarball/v0.0.3",
                           "commit"      =>
                             { "sha" => "a0cba2b1a1ea9011ab07ee1ac140ba5a5eb8bd90",
                               "url" =>
                                 "https://api.github.com/repos/skywinder/changelog_test/commits/a0cba2b1a1ea9011ab07ee1ac140ba5a5eb8bd90" } },
                         { "name"        => "v0.0.2",
                           "zipball_url" =>
                             "https://api.github.com/repos/skywinder/changelog_test/zipball/v0.0.2",
                           "tarball_url" =>
                             "https://api.github.com/repos/skywinder/changelog_test/tarball/v0.0.2",
                           "commit"      =>
                             { "sha" => "9b35bb13dcd15b68e7bcbf10cde5eb937a54f710",
                               "url" =>
                                 "https://api.github.com/repos/skywinder/changelog_test/commits/9b35bb13dcd15b68e7bcbf10cde5eb937a54f710" } },
                         { "name"        => "v0.0.1",
                           "zipball_url" =>
                             "https://api.github.com/repos/skywinder/changelog_test/zipball/v0.0.1",
                           "tarball_url" =>
                             "https://api.github.com/repos/skywinder/changelog_test/tarball/v0.0.1",
                           "commit"      =>
                             { "sha" => "4c2d6d1ed58bdb24b870dcb5d9f2ceed0283d69d",
                               "url" =>
                                 "https://api.github.com/repos/skywinder/changelog_test/commits/4c2d6d1ed58bdb24b870dcb5d9f2ceed0283d69d" } },
                         { "name"        => "0.0.4",
                           "zipball_url" =>
                             "https://api.github.com/repos/skywinder/changelog_test/zipball/0.0.4",
                           "tarball_url" =>
                             "https://api.github.com/repos/skywinder/changelog_test/tarball/0.0.4",
                           "commit"      =>
                             { "sha" => "ece0c3ab7142b21064b885061c55ede00ef6ce94",
                               "url" =>
                                 "https://api.github.com/repos/skywinder/changelog_test/commits/ece0c3ab7142b21064b885061c55ede00ef6ce94" } }]

        expect(fetcher.github_fetch_tags).to eq(expected_tags)
      end

      it "should return tags count" do
        tags = fetcher.github_fetch_tags
        expect(tags.size).to eq(4)
      end
    end
  end

  describe "#fetch_closed_issues_and_pr" do
    context "when API call is valid", :vcr do
      it "returns issues" do
        issues, pull_requests = fetcher.fetch_closed_issues_and_pr
        expect(issues.size).to eq(7)
        expect(pull_requests.size).to eq(14)
      end

      it "returns issue with proper key/values" do
        issues, _pull_requests = fetcher.fetch_closed_issues_and_pr

        expected_issue = { "url"            => "https://api.github.com/repos/skywinder/changelog_test/issues/14",
                           "repository_url" => "https://api.github.com/repos/skywinder/changelog_test",
                           "labels_url"     =>
                             "https://api.github.com/repos/skywinder/changelog_test/issues/14/labels{/name}",
                           "comments_url"   =>
                             "https://api.github.com/repos/skywinder/changelog_test/issues/14/comments",
                           "events_url"     =>
                             "https://api.github.com/repos/skywinder/changelog_test/issues/14/events",
                           "html_url"       => "https://github.com/skywinder/changelog_test/issues/14",
                           "id"             => 95_419_412,
                           "number"         => 14,
                           "title"          => "Issue closed from commit from PR",
                           "user"           =>
                             { "login"               => "skywinder",
                               "id"                  => 3_356_474,
                               "avatar_url"          => "https://avatars.githubusercontent.com/u/3356474?v=3",
                               "gravatar_id"         => "",
                               "url"                 => "https://api.github.com/users/skywinder",
                               "html_url"            => "https://github.com/skywinder",
                               "followers_url"       => "https://api.github.com/users/skywinder/followers",
                               "following_url"       =>
                                 "https://api.github.com/users/skywinder/following{/other_user}",
                               "gists_url"           => "https://api.github.com/users/skywinder/gists{/gist_id}",
                               "starred_url"         =>
                                 "https://api.github.com/users/skywinder/starred{/owner}{/repo}",
                               "subscriptions_url"   => "https://api.github.com/users/skywinder/subscriptions",
                               "organizations_url"   => "https://api.github.com/users/skywinder/orgs",
                               "repos_url"           => "https://api.github.com/users/skywinder/repos",
                               "events_url"          => "https://api.github.com/users/skywinder/events{/privacy}",
                               "received_events_url" =>
                                 "https://api.github.com/users/skywinder/received_events",
                               "type"                => "User",
                               "site_admin"          => false },
                           "labels"         => [],
                           "state"          => "closed",
                           "locked"         => false,
                           "assignee"       => nil,
                           "assignees" => [],
                           "milestone"      => nil,
                           "comments"       => 0,
                           "created_at"     => "2015-07-16T12:06:08Z",
                           "updated_at"     => "2015-07-16T12:21:42Z",
                           "closed_at"      => "2015-07-16T12:21:42Z",
                           "body"           => "" }

        # Convert times to Time
        expected_issue.each_pair do |k, v|
          expected_issue[k] = Time.parse(v) if v =~ /^2015-/
        end

        expect(issues.first).to eq(expected_issue)
      end

      it "returns pull request with proper key/values" do
        _issues, pull_requests = fetcher.fetch_closed_issues_and_pr

        expected_pr = { "url"            => "https://api.github.com/repos/skywinder/changelog_test/issues/21",
                        "repository_url" => "https://api.github.com/repos/skywinder/changelog_test",
                        "labels_url"     =>
                          "https://api.github.com/repos/skywinder/changelog_test/issues/21/labels{/name}",
                        "comments_url"   =>
                          "https://api.github.com/repos/skywinder/changelog_test/issues/21/comments",
                        "events_url"     =>
                          "https://api.github.com/repos/skywinder/changelog_test/issues/21/events",
                        "html_url"       => "https://github.com/skywinder/changelog_test/pull/21",
                        "id"             => 124_925_759,
                        "number"         => 21,
                        "title"          => "Merged br (should appear in change log with  #20)",
                        "user"           =>
                          { "login"               => "skywinder",
                            "id"                  => 3_356_474,
                            "avatar_url"          => "https://avatars.githubusercontent.com/u/3356474?v=3",
                            "gravatar_id"         => "",
                            "url"                 => "https://api.github.com/users/skywinder",
                            "html_url"            => "https://github.com/skywinder",
                            "followers_url"       => "https://api.github.com/users/skywinder/followers",
                            "following_url"       =>
                              "https://api.github.com/users/skywinder/following{/other_user}",
                            "gists_url"           => "https://api.github.com/users/skywinder/gists{/gist_id}",
                            "starred_url"         =>
                              "https://api.github.com/users/skywinder/starred{/owner}{/repo}",
                            "subscriptions_url"   => "https://api.github.com/users/skywinder/subscriptions",
                            "organizations_url"   => "https://api.github.com/users/skywinder/orgs",
                            "repos_url"           => "https://api.github.com/users/skywinder/repos",
                            "events_url"          => "https://api.github.com/users/skywinder/events{/privacy}",
                            "received_events_url" =>
                              "https://api.github.com/users/skywinder/received_events",
                            "type"                => "User",
                            "site_admin"          => false },
                        "labels"         => [],
                        "state"          => "closed",
                        "locked"         => false,
                        "assignee"       => nil,
                        "assignees" => [],
                        "milestone"      => nil,
                        "comments"       => 0,
                        "created_at"     => "2016-01-05T09:24:08Z",
                        "updated_at"     => "2016-01-05T09:26:53Z",
                        "closed_at"      => "2016-01-05T09:24:27Z",
                        "pull_request"   =>
                          { "url"       => "https://api.github.com/repos/skywinder/changelog_test/pulls/21",
                            "html_url"  => "https://github.com/skywinder/changelog_test/pull/21",
                            "diff_url"  => "https://github.com/skywinder/changelog_test/pull/21.diff",
                            "patch_url" => "https://github.com/skywinder/changelog_test/pull/21.patch" },
                        "body"           =>
                          "to test https://github.com/skywinder/github-changelog-generator/pull/305\r\nshould appear in change log with #20" }

        # Convert times to Time
        expected_pr.each_pair do |k, v|
          expected_pr[k] = Time.parse(v) if v =~ /^2016-01/
        end

        expect(pull_requests.first).to eq(expected_pr)
      end

      it "returns issues with labels" do
        issues, _pull_requests = fetcher.fetch_closed_issues_and_pr
        expected = [[], [], ["Bug"], [], ["enhancement"], ["some label"], []]
        expect(issues.map { |i| i["labels"].map { |l| l["name"] } }).to eq(expected)
      end

      it "returns pull_requests with labels" do
        _issues, pull_requests = fetcher.fetch_closed_issues_and_pr
        expected = [[], [], [], [], [], ["enhancement"], [], [], ["invalid"], [], [], [], [], ["invalid"]]
        expect(pull_requests.map { |i| i["labels"].map { |l| l["name"] } }).to eq(expected)
      end
    end
  end

  describe "#fetch_closed_pull_requests" do
    context "when API call is valid", :vcr do
      it "returns pull requests" do
        pull_requests = fetcher.fetch_closed_pull_requests
        expect(pull_requests.size).to eq(14)
      end

      it "returns correct pull request keys" do
        pull_requests = fetcher.fetch_closed_pull_requests

        pr = pull_requests.first
        expect(pr.keys).to eq(%w(url id html_url diff_url patch_url issue_url number state locked title user body created_at updated_at closed_at merged_at merge_commit_sha assignee assignees milestone commits_url review_comments_url review_comment_url comments_url statuses_url head base _links))
      end
    end
  end

  describe "#fetch_events_async" do
    context "when API call is valid", :vcr do
      it "populates issues" do
        issues = [{ "url"            => "https://api.github.com/repos/skywinder/changelog_test/issues/14",
                    "repository_url" => "https://api.github.com/repos/skywinder/changelog_test",
                    "labels_url"     =>
                      "https://api.github.com/repos/skywinder/changelog_test/issues/14/labels{/name}",
                    "comments_url"   =>
                      "https://api.github.com/repos/skywinder/changelog_test/issues/14/comments",
                    "events_url"     =>
                      "https://api.github.com/repos/skywinder/changelog_test/issues/14/events",
                    "html_url"       => "https://github.com/skywinder/changelog_test/issues/14",
                    "id"             => 95_419_412,
                    "number"         => 14,
                    "title"          => "Issue closed from commit from PR",
                    "user"           =>
                      { "login"               => "skywinder",
                        "id"                  => 3_356_474,
                        "avatar_url"          => "https://avatars.githubusercontent.com/u/3356474?v=3",
                        "gravatar_id"         => "",
                        "url"                 => "https://api.github.com/users/skywinder",
                        "html_url"            => "https://github.com/skywinder",
                        "followers_url"       => "https://api.github.com/users/skywinder/followers",
                        "following_url"       =>
                          "https://api.github.com/users/skywinder/following{/other_user}",
                        "gists_url"           => "https://api.github.com/users/skywinder/gists{/gist_id}",
                        "starred_url"         =>
                          "https://api.github.com/users/skywinder/starred{/owner}{/repo}",
                        "subscriptions_url"   =>
                          "https://api.github.com/users/skywinder/subscriptions",
                        "organizations_url"   => "https://api.github.com/users/skywinder/orgs",
                        "repos_url"           => "https://api.github.com/users/skywinder/repos",
                        "events_url"          => "https://api.github.com/users/skywinder/events{/privacy}",
                        "received_events_url" =>
                          "https://api.github.com/users/skywinder/received_events",
                        "type"                => "User",
                        "site_admin"          => false },
                    "labels"         => [],
                    "state"          => "closed",
                    "locked"         => false,
                    "assignee"       => nil,
                    "assignees" => [],
                    "milestone"      => nil,
                    "comments"       => 0,
                    "created_at"     => "2015-07-16T12:06:08Z",
                    "updated_at"     => "2015-07-16T12:21:42Z",
                    "closed_at"      => "2015-07-16T12:21:42Z",
                    "body"           => "" }]

        # Check that they are blank to begin with
        expect(issues.first["events"]).to be_nil

        fetcher.fetch_events_async(issues)
        issue_events = issues.first["events"]

        expected_events = [{ "id"         => 357_462_189,
                             "url"        =>
                               "https://api.github.com/repos/skywinder/changelog_test/issues/events/357462189",
                             "actor"      =>
                               { "login"               => "skywinder",
                                 "id"                  => 3_356_474,
                                 "avatar_url"          => "https://avatars.githubusercontent.com/u/3356474?v=3",
                                 "gravatar_id"         => "",
                                 "url"                 => "https://api.github.com/users/skywinder",
                                 "html_url"            => "https://github.com/skywinder",
                                 "followers_url"       => "https://api.github.com/users/skywinder/followers",
                                 "following_url"       =>
                                   "https://api.github.com/users/skywinder/following{/other_user}",
                                 "gists_url"           => "https://api.github.com/users/skywinder/gists{/gist_id}",
                                 "starred_url"         =>
                                   "https://api.github.com/users/skywinder/starred{/owner}{/repo}",
                                 "subscriptions_url"   =>
                                   "https://api.github.com/users/skywinder/subscriptions",
                                 "organizations_url"   => "https://api.github.com/users/skywinder/orgs",
                                 "repos_url"           => "https://api.github.com/users/skywinder/repos",
                                 "events_url"          => "https://api.github.com/users/skywinder/events{/privacy}",
                                 "received_events_url" =>
                                   "https://api.github.com/users/skywinder/received_events",
                                 "type"                => "User",
                                 "site_admin"          => false },
                             "event"      => "referenced",
                             "commit_id"  => "decfe840d1a1b86e0c28700de5362d3365a29555",
                             "commit_url" =>
                               "https://api.github.com/repos/skywinder/changelog_test/commits/decfe840d1a1b86e0c28700de5362d3365a29555",
                             "created_at" => "2015-07-16T12:21:16Z" },
                           { "id"         => 357_462_542,
                             "url"        =>
                               "https://api.github.com/repos/skywinder/changelog_test/issues/events/357462542",
                             "actor"      =>
                               { "login"               => "skywinder",
                                 "id"                  => 3_356_474,
                                 "avatar_url"          => "https://avatars.githubusercontent.com/u/3356474?v=3",
                                 "gravatar_id"         => "",
                                 "url"                 => "https://api.github.com/users/skywinder",
                                 "html_url"            => "https://github.com/skywinder",
                                 "followers_url"       => "https://api.github.com/users/skywinder/followers",
                                 "following_url"       =>
                                   "https://api.github.com/users/skywinder/following{/other_user}",
                                 "gists_url"           => "https://api.github.com/users/skywinder/gists{/gist_id}",
                                 "starred_url"         =>
                                   "https://api.github.com/users/skywinder/starred{/owner}{/repo}",
                                 "subscriptions_url"   =>
                                   "https://api.github.com/users/skywinder/subscriptions",
                                 "organizations_url"   => "https://api.github.com/users/skywinder/orgs",
                                 "repos_url"           => "https://api.github.com/users/skywinder/repos",
                                 "events_url"          => "https://api.github.com/users/skywinder/events{/privacy}",
                                 "received_events_url" =>
                                   "https://api.github.com/users/skywinder/received_events",
                                 "type"                => "User",
                                 "site_admin"          => false },
                             "event"      => "closed",
                             "commit_id"  => "decfe840d1a1b86e0c28700de5362d3365a29555",
                             "commit_url" =>
                               "https://api.github.com/repos/skywinder/changelog_test/commits/decfe840d1a1b86e0c28700de5362d3365a29555",
                             "created_at" => "2015-07-16T12:21:42Z" }]

        # Convert times to Time
        expected_events.map! do |event|
          event.each_pair do |k, v|
            event[k] = Time.parse(v) if v =~ /^201[56]-/
          end
        end

        expect(issue_events).to eq(expected_events)
      end
    end
  end

  describe "#fetch_date_of_tag" do
    context "when API call is valid", :vcr do
      it "returns date" do
        tag = { "name"        => "v0.0.3",
                "zipball_url" =>
                  "https://api.github.com/repos/skywinder/changelog_test/zipball/v0.0.3",
                "tarball_url" =>
                  "https://api.github.com/repos/skywinder/changelog_test/tarball/v0.0.3",
                "commit"      =>
                  { "sha" => "a0cba2b1a1ea9011ab07ee1ac140ba5a5eb8bd90",
                    "url" =>
                      "https://api.github.com/repos/skywinder/changelog_test/commits/a0cba2b1a1ea9011ab07ee1ac140ba5a5eb8bd90" } }

        dt = fetcher.fetch_date_of_tag(tag)
        expect(dt).to eq(Time.parse("2015-03-04 19:01:48 UTC"))
      end
    end
  end

  describe "#querystring_as_hash" do
    it "works on the blank URL" do
      expect { fetcher.send(:querystring_as_hash, "") }.not_to raise_error
    end

    it "where there are no querystring params" do
      expect { fetcher.send(:querystring_as_hash, "http://example.com") }.not_to raise_error
    end

    it "returns a String-keyed Hash of querystring params" do
      expect(fetcher.send(:querystring_as_hash, "http://example.com/o.html?str=18&wis=12")).to include("wis" => "12", "str" => "18")
    end
  end

  describe "#fetch_commit" do
    context "when API call is valid", :vcr do
      it "returns commit" do
        event = { "id"         => 357_462_189,
                  "url"        =>
                    "https://api.github.com/repos/skywinder/changelog_test/issues/events/357462189",
                  "actor"      =>
                    { "login"               => "skywinder",
                      "id"                  => 3_356_474,
                      "avatar_url"          => "https://avatars.githubusercontent.com/u/3356474?v=3",
                      "gravatar_id"         => "",
                      "url"                 => "https://api.github.com/users/skywinder",
                      "html_url"            => "https://github.com/skywinder",
                      "followers_url"       => "https://api.github.com/users/skywinder/followers",
                      "following_url"       =>
                        "https://api.github.com/users/skywinder/following{/other_user}",
                      "gists_url"           => "https://api.github.com/users/skywinder/gists{/gist_id}",
                      "starred_url"         =>
                        "https://api.github.com/users/skywinder/starred{/owner}{/repo}",
                      "subscriptions_url"   => "https://api.github.com/users/skywinder/subscriptions",
                      "organizations_url"   => "https://api.github.com/users/skywinder/orgs",
                      "repos_url"           => "https://api.github.com/users/skywinder/repos",
                      "events_url"          => "https://api.github.com/users/skywinder/events{/privacy}",
                      "received_events_url" =>
                        "https://api.github.com/users/skywinder/received_events",
                      "type"                => "User",
                      "site_admin"          => false },
                  "event"      => "referenced",
                  "commit_id"  => "decfe840d1a1b86e0c28700de5362d3365a29555",
                  "commit_url" =>
                    "https://api.github.com/repos/skywinder/changelog_test/commits/decfe840d1a1b86e0c28700de5362d3365a29555",
                  "created_at" => "2015-07-16T12:21:16Z" }
        commit = fetcher.fetch_commit(event)

        expectations = [
          %w(sha decfe840d1a1b86e0c28700de5362d3365a29555),
          ["url",
           "https://api.github.com/repos/skywinder/changelog_test/commits/decfe840d1a1b86e0c28700de5362d3365a29555"],
          # OLD API: "https://api.github.com/repos/skywinder/changelog_test/git/commits/decfe840d1a1b86e0c28700de5362d3365a29555"],
          ["html_url",
           "https://github.com/skywinder/changelog_test/commit/decfe840d1a1b86e0c28700de5362d3365a29555"],
          ["author",
           { "login" => "skywinder", "id" => 3_356_474, "avatar_url" => "https://avatars.githubusercontent.com/u/3356474?v=3", "gravatar_id" => "", "url" => "https://api.github.com/users/skywinder", "html_url" => "https://github.com/skywinder", "followers_url" => "https://api.github.com/users/skywinder/followers", "following_url" => "https://api.github.com/users/skywinder/following{/other_user}", "gists_url" => "https://api.github.com/users/skywinder/gists{/gist_id}", "starred_url" => "https://api.github.com/users/skywinder/starred{/owner}{/repo}", "subscriptions_url" => "https://api.github.com/users/skywinder/subscriptions", "organizations_url" => "https://api.github.com/users/skywinder/orgs", "repos_url" => "https://api.github.com/users/skywinder/repos", "events_url" => "https://api.github.com/users/skywinder/events{/privacy}", "received_events_url" => "https://api.github.com/users/skywinder/received_events", "type" => "User", "site_admin" => false }],
          ["committer",
           { "login" => "skywinder", "id" => 3_356_474, "avatar_url" => "https://avatars.githubusercontent.com/u/3356474?v=3", "gravatar_id" => "", "url" => "https://api.github.com/users/skywinder", "html_url" => "https://github.com/skywinder", "followers_url" => "https://api.github.com/users/skywinder/followers", "following_url" => "https://api.github.com/users/skywinder/following{/other_user}", "gists_url" => "https://api.github.com/users/skywinder/gists{/gist_id}", "starred_url" => "https://api.github.com/users/skywinder/starred{/owner}{/repo}", "subscriptions_url" => "https://api.github.com/users/skywinder/subscriptions", "organizations_url" => "https://api.github.com/users/skywinder/orgs", "repos_url" => "https://api.github.com/users/skywinder/repos", "events_url" => "https://api.github.com/users/skywinder/events{/privacy}", "received_events_url" => "https://api.github.com/users/skywinder/received_events", "type" => "User", "site_admin" => false }],
          ["parents",
           [{ "sha" => "7ec095e5e3caceacedabf44d0b9b10da17c92e51",
              "url" =>
               "https://api.github.com/repos/skywinder/changelog_test/commits/7ec095e5e3caceacedabf44d0b9b10da17c92e51",
              # OLD API: "https://api.github.com/repos/skywinder/changelog_test/git/commits/7ec095e5e3caceacedabf44d0b9b10da17c92e51",
              "html_url" =>
               "https://github.com/skywinder/changelog_test/commit/7ec095e5e3caceacedabf44d0b9b10da17c92e51" }]]
        ]

        expectations.each do |property, val|
          expect(commit[property]).to eq(val)
        end
      end
    end
  end

  describe "#commits_before" do
    context "when API is valid", :vcr do
      let(:start_time) { Time.parse("Wed Mar 4 18:47:17 2015 +0200") }

      subject do
        fetcher.commits_before(start_time)
      end

      it "returns commits" do
        expect(subject.last["sha"]).to eq("4c2d6d1ed58bdb24b870dcb5d9f2ceed0283d69d")
      end
    end
  end
end
