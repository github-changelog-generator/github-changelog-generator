# frozen_string_literal: true

module GitHubChangelogGenerator
  class Generator
    # Fetch event for issues and pull requests
    # @return [Array] array of fetched issues
    def fetch_events_for_issues_and_pr
      print "Fetching events for issues and PR: 0/#{@issues.count + @pull_requests.count}\r" if options[:verbose]

      # Async fetching events:
      @fetcher.fetch_events_async(@issues + @pull_requests)
    end

    # Async fetching of all tags dates
    def fetch_tags_dates(tags)
      print "Fetching tag dates...\r" if options[:verbose]
      i = 0
      tags.each do |tag|
        get_time_of_tag(tag)
        i += 1
      end
      puts "Fetching tags dates: #{i}/#{tags.count}" if options[:verbose]
    end

    # Find correct closed dates, if issues was closed by commits
    def detect_actual_closed_dates(issues)
      print "Fetching closed dates for issues...\r" if options[:verbose]

      i = 0
      issues.each do |issue|
        find_closed_date_by_commit(issue)
        i += 1
      end
      puts "Fetching closed dates for issues: #{i}/#{issues.count}" if options[:verbose]
    end

    # Adds a key "first_occurring_tag" to each PR with a value of the oldest
    # tag that a PR's merge commit occurs in in the git history. This should
    # indicate the release of each PR by git's history regardless of dates and
    # divergent branches.
    #
    # @param [Array] tags The tags sorted by time, newest to oldest.
    # @param [Array] prs The PRs to discover the tags of.
    # @return [Nil] No return; PRs are updated in-place.
    def add_first_occurring_tag_to_prs(tags, prs)
      total = prs.count

      prs_left = associate_tagged_prs(tags, prs, total)
      prs_left = associate_release_branch_prs(prs_left, total)
      prs_left = associate_rebase_comment_prs(tags, prs_left, total) if prs_left.any?
      # PRs in prs_left will be untagged, not in release branch, and not
      # rebased. They should not be included in the changelog as they probably
      # have been merged to a branch other than the release branch.
      @pull_requests -= prs_left
      Helper.log.info "Associating PRs with tags: #{total}/#{total}"
    end

    # Associate merged PRs by the merge SHA contained in each tag. If the
    # merge_commit_sha is not found in any tag's history, skip association.
    #
    # @param [Array] tags The tags sorted by time, newest to oldest.
    # @param [Array] prs The PRs to associate.
    # @return [Array] PRs without their merge_commit_sha in a tag.
    def associate_tagged_prs(tags, prs, total)
      @fetcher.fetch_tag_shas(tags)

      i = 0
      prs.reject do |pr|
        found = false
        # XXX Wish I could use merge_commit_sha, but gcg doesn't currently
        # fetch that. See
        # https://developer.github.com/v3/pulls/#get-a-single-pull-request vs.
        # https://developer.github.com/v3/pulls/#list-pull-requests
        if pr["events"] && (event = pr["events"].find { |e| e["event"] == "merged" })
          # Iterate tags.reverse (oldest to newest) to find first tag of each PR.
          if (oldest_tag = tags.reverse.find { |tag| tag["shas_in_tag"].include?(event["commit_id"]) })
            pr["first_occurring_tag"] = oldest_tag["name"]
            found = true
            i += 1
            print("Associating PRs with tags: #{i}/#{total}\r") if @options[:verbose]
          end
        else
          # Either there were no events or no merged event. Github's api can be
          # weird like that apparently. Check for a rebased comment before erroring.
          no_events_pr = associate_rebase_comment_prs(tags, [pr], total)
          raise StandardError, "No merge sha found for PR #{pr['number']} via the GitHub API" unless no_events_pr.empty?

          found = true
          i += 1
          print("Associating PRs with tags: #{i}/#{total}\r") if @options[:verbose]
        end
        found
      end
    end

    # Associate merged PRs by the HEAD of the release branch. If no
    # --release-branch was specified, then the github default branch is used.
    #
    # @param [Array] prs_left PRs not associated with any tag.
    # @param [Integer] total The total number of PRs to associate; used for verbose printing.
    # @return [Array] PRs without their merge_commit_sha in the branch.
    def associate_release_branch_prs(prs_left, total)
      if prs_left.any?
        i = total - prs_left.count
        prs_left.reject do |pr|
          found = false
          if pr["events"] && (event = pr["events"].find { |e| e["event"] == "merged" }) && sha_in_release_branch?(event["commit_id"])
            found = true
            i += 1
            print("Associating PRs with tags: #{i}/#{total}\r") if @options[:verbose]
          end
          found
        end
      else
        prs_left
      end
    end

    # Associate merged PRs by the SHA detected in github comments of the form
    # "rebased commit: <sha>". For use when the merge_commit_sha is not in the
    # actual git history due to rebase.
    #
    # @param [Array] tags The tags sorted by time, newest to oldest.
    # @param [Array] prs_left The PRs not yet associated with any tag or branch.
    # @return [Array] PRs without rebase comments.
    def associate_rebase_comment_prs(tags, prs_left, total)
      i = total - prs_left.count
      # Any remaining PRs were not found in the list of tags by their merge
      # commit and not found in any specified release branch. Fallback to
      # rebased commit comment.
      @fetcher.fetch_comments_async(prs_left)
      prs_left.reject do |pr|
        found = false
        if pr["comments"] && (rebased_comment = pr["comments"].reverse.find { |c| c["body"].match(%r{rebased commit: ([0-9a-f]{40})}i) })
          rebased_sha = rebased_comment["body"].match(%r{rebased commit: ([0-9a-f]{40})}i)[1]
          if (oldest_tag = tags.reverse.find { |tag| tag["shas_in_tag"].include?(rebased_sha) })
            pr["first_occurring_tag"] = oldest_tag["name"]
            found = true
            i += 1
          elsif sha_in_release_branch?(rebased_sha)
            found = true
            i += 1
          else
            raise StandardError, "PR #{pr['number']} has a rebased SHA comment but that SHA was not found in the release branch or any tags"
          end
          print("Associating PRs with tags: #{i}/#{total}\r") if @options[:verbose]
        else
          puts "Warning: PR #{pr['number']} merge commit was not found in the release branch or tagged git history and no rebased SHA comment was found"
        end
        found
      end
    end

    # Fill :actual_date parameter of specified issue by closed date of the commit, if it was closed by commit.
    # @param [Hash] issue
    def find_closed_date_by_commit(issue)
      unless issue["events"].nil?
        # if it's PR -> then find "merged event", in case of usual issue -> fond closed date
        compare_string = issue["merged_at"].nil? ? "closed" : "merged"
        # reverse! - to find latest closed event. (event goes in date order)
        issue["events"].reverse!.each do |event|
          if event["event"].eql? compare_string
            set_date_from_event(event, issue)
            break
          end
        end
      end
      # TODO: assert issues, that remain without 'actual_date' hash for some reason.
    end

    # Set closed date from this issue
    #
    # @param [Hash] event
    # @param [Hash] issue
    def set_date_from_event(event, issue)
      if event["commit_id"].nil?
        issue["actual_date"] = issue["closed_at"]
      else
        begin
          commit = @fetcher.fetch_commit(event["commit_id"])
          issue["actual_date"] = commit["commit"]["author"]["date"]

          # issue['actual_date'] = commit['author']['date']
        rescue StandardError
          puts "Warning: Can't fetch commit #{event['commit_id']}. It is probably referenced from another repo."
          issue["actual_date"] = issue["closed_at"]
        end
      end
    end

    private

    # Detect if a sha occurs in the --release-branch. Uses the github repo
    # default branch if not specified.
    #
    # @param [String] sha SHA to check.
    # @return [Boolean] True if SHA is in the branch git history.
    def sha_in_release_branch?(sha)
      branch = @options[:release_branch] || @fetcher.default_branch
      @fetcher.commits_in_branch(branch).include?(sha)
    end
  end
end
