module GitHubChangelogGenerator
  class Generator
    # Fetch event for issues and pull requests
    # @return [Array] array of fetched issues
    def fetch_event_for_issues_and_pr
      if @options[:verbose]
        print "Fetching events for issues and PR: 0/#{@issues.count + @pull_requests.count}\r"
      end

      # Async fetching events:
      @fetcher.fetch_events_async(@issues + @pull_requests)
    end
  end
end
