# frozen_string_literal: true
module GitHubChangelogGenerator
  class Generator
    MAX_THREAD_NUMBER = 25

    # Fetch event for issues and pull requests
    # @return [Array] array of fetched issues
    def fetch_events_for_issues_and_pr
      if options[:verbose]
        print "Fetching events for issues and PR: 0/#{@issues.count + @pull_requests.count}\r"
      end

      # Async fetching events:
      @fetcher.fetch_events_async(@issues + @pull_requests)
    end

    # Async fetching of all tags dates
    def fetch_tags_dates(tags)
      print "Fetching tag dates...\r" if options[:verbose]
      # Async fetching tags:
      threads = []
      i = 0
      all = tags.count
      tags.each do |tag|
        print "                                 \r"
        threads << Thread.new do
          get_time_of_tag(tag)
          print "Fetching tags dates: #{i + 1}/#{all}\r" if options[:verbose]
          i += 1
        end
      end
      threads.each(&:join)
      puts "Fetching tags dates: #{i}" if options[:verbose]
    end

    # Find correct closed dates, if issues was closed by commits
    def detect_actual_closed_dates(issues)
      print "Fetching closed dates for issues...\r" if options[:verbose]

      issues.each_slice(MAX_THREAD_NUMBER) do |issues_slice|
        threads = []
        issues_slice.each do |issue|
          threads << Thread.new { find_closed_date_by_commit(issue) }
        end
        threads.each(&:join)
      end
      puts "Fetching closed dates for issues: Done!" if options[:verbose]
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
          commit = @fetcher.fetch_commit(event)
          issue["actual_date"] = commit["commit"]["author"]["date"]

          # issue['actual_date'] = commit['author']['date']
        rescue
          puts "Warning: Can't fetch commit #{event['commit_id']}. It is probably referenced from another repo."
          issue["actual_date"] = issue["closed_at"]
        end
      end
    end
  end
end
