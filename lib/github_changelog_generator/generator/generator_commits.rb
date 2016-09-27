module GitHubChangelogGenerator
  class Generator
    def fetch_commits_on_master
      @master_commits = @fetcher.fetch_master_commits
    rescue
      puts "Something went wrong in fetch commits"
      exit 1
    end
  end
end
