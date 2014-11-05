require_relative 'constants'
require_relative 'parser'
require 'github_api'
require 'json'
require 'httparty'


class ChangelogGenerator

  attr_accessor :options, :all_tags

  def initialize()
    @options = Parser.new.options
    if $oauth_token
      @github = Github.new oauth_token: $oauth_token
    else
      @github = Github.new
    end
    @all_tags = self.get_all_tags
  end

  def print_json(json)
    puts JSON.pretty_generate(json)
  end

  def exec_command(cmd)
    exec_cmd = "cd #{$project_path} && #{cmd}"
    %x[#{exec_cmd}]
  end


  def get_all_closed_pull_requests

    issues = @github.pull_requests.list $github_user, $github_repo_name, :state => 'closed'
    json = issues.body

    if @options[:verbose]
      # puts 'All pull requests:'
      # json.each { |dict|
      #   p "##{dict[:number]} - #{dict[:title]} (#{dict[:closed_at]})"
      # }
    end

    json

  end

  def compund_changelog_for_last_tag
    if @options[:verbose]
      puts 'Generating changelog:'
    end
    log = ''
    prev_tag = self.all_tags[1]
    last_tag = self.all_tags[0]

    log += self.generate_log_between_tags(prev_tag, last_tag)
    puts log
    File.open('output.txt', 'w') { |file| file.write(log) }

  end

  def is_megred(number)
    @github.pull_requests.merged? $github_user, $github_repo_name, number
  end

  def get_all_merged_pull_requests
    json = self.get_all_closed_pull_requests
    puts 'Check if the requests is merged... (it can take a while)'

    json.delete_if { |req|
      merged = self.is_megred(req[:number])
      if @options[:verbose]
        puts "##{req[:number]} #{merged ? 'merged' : 'not merged'}"
      end
      !merged
    }
  end

  def get_all_tags
    url = "https://api.github.com/repos/#{$github_user}/#{$github_repo_name}/tags"
    response = HTTParty.get(url,
                            :headers => {'Authorization' => 'token 8587bb22f6bf125454768a4a19dbcc774ea68d48',
                                        'User-Agent' => 'Changelog-Generator'})

    json_parse = JSON.parse(response.body)
  end

  def generate_log_between_tags(prev_tag, last_tag)

    last_tag_name = last_tag['name']
    log = ''
    prev_tag_time = self.get_time_of_tag(prev_tag)
    pull_requests = self.get_all_closed_pull_requests

    pull_requests.delete_if { |req|
      t = Time.parse(req[:closed_at]).utc
      t < prev_tag_time
    }

    log += "## [#{last_tag_name}] (https://github.com/#{$github_user}/#{$github_repo_name}/tree/#{last_tag_name})\n"

    time_string = prev_tag_time.strftime "%Y/%m/%d"
    log += "#### #{time_string}\n"

    pull_requests.each { |dict|
      merge = "#{dict[:title]} ([\\##{dict[:number]}](https://github.com/#{$github_user}/#{$github_repo_name}/pull/#{dict[:number]}))\n"
      log += "- #{merge}"
    }

    log
  end

  def get_time_of_tag(prev_tag)
    github_git_data_commits_get = @github.git_data.commits.get $github_user, $github_repo_name, prev_tag['commit']['sha']
    time_string = github_git_data_commits_get['committer']['date']
    Time.parse(time_string)

  end

end

if __FILE__ == $0

  log_generator = ChangelogGenerator.new

  log_generator.compund_changelog_for_last_tag

  # log_generator.generate_log_between_tags(tags[1], tags[2])
end