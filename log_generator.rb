require_relative 'constants'
require 'github_api'
require 'json'
require 'httparty'

class LogGenerator

  attr_accessor :options, :all_tags

  def initialize(options = {})
    @options = options
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

  def find_prev_tag
    var = self.all_tags[1]
    p var
  end


  def get_all_closed_pull_requests

    issues = @github.pull_requests.list $github_user, $github_repo_name, :state => 'closed'
    json = issues.body

    if @options[:verbose]
      puts 'All pull requests:'
      json.each { |dict|
        p "##{dict[:number]} - #{dict[:title]} (#{dict[:closed_at]})"
      }
    end

    json

  end

  def compund_changelog(prev_tag)
    if @options[:verbose]
      puts 'Generating changelog:'
    end
    log = ''
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
    url = "https://api.github.com/repos/skywinder/ActionSheetPicker-3.0/tags"
    so_url = 'https://api.stackexchange.com/2.2/questions?site=stackoverflow'
    response = HTTParty.get(url,
                            :headers => { "Authorization" => "token 8587bb22f6bf125454768a4a19dbcc774ea68d48",
                                          "User-Agent" => "APPLICATION_NAME"})

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
    self.print_json github_git_data_commits_get.body
    time_string = github_git_data_commits_get['committer']['date']
    Time.parse(time_string)

  end

end

if __FILE__ == $0

  log_generator = LogGenerator.new({:verbose => true})

  tags = log_generator.all_tags

  log_generator.generate_log_between_tags(tags[1], tags[2])
end