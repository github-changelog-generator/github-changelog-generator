require_relative 'constants'
require 'github_api'
require 'json'

class LogGenerator

  attr_accessor :options

  def initialize(options = {})
    @options = options
    if $oauth_token
      @github = Github.new oauth_token: $oauth_token
    else
      @github = Github.new
    end
  end

  def print_json(json)
    puts JSON.pretty_generate(json)
  end

  def exec_command(cmd)
    exec_cmd = "cd #{$project_path} && #{cmd}"
    %x[#{exec_cmd}]
  end

  def find_prev_tag_date

    value1 = exec_command "git log --tags --simplify-by-decoration --pretty=\"format:%ci %d\" | grep tag"
    unless value1
      puts 'not found this tag'
      exit
    end

    scan_results = value1.scan(/.*tag.*/)

    prev_tag = scan_results[1]

    unless scan_results.any?
      puts 'Not found any versions -> exit'
      exit
    end

    if @options[:verbose]
      puts "Prev tag is #{prev_tag}"
    end
    time = Time.parse(prev_tag)
  end


  def get_all_closed_pull_requests

    issues = @github.pull_requests.list $github_user, $github_repo_name, :state => 'closed'
    json = issues.body

    json.each { |dict|
      # print_json dict
      # puts "##{dict[:number]} - #{dict[:title]} (#{dict[:closed_at]})"
    }

    json

  end

  def compund_changelog(tag_time, pull_requests)
    log = ''
    last_tag = exec_command('git describe --abbrev=0 --tags').strip
    log += "## [#{last_tag}] (https://github.com/#{$github_user}/#{$github_repo_name}/tree/#{last_tag})\n"

    time_string = tag_time.strftime "%Y/%m/%d"
    log += "#### #{time_string}\n"

    pull_requests.each { |dict|
      merge = "#{dict[:title]} ([\\##{dict[:number]}](https://github.com/#{$github_user}/#{$github_repo_name}/pull/#{dict[:number]}))\n"
      log += "- #{merge}"
    }

    puts log
    File.open('output.txt', 'w') { |file| file.write(log) }

  end

  def is_megred(number)
    @github.pull_requests.merged? $github_user, $github_repo_name, number
  end

  def get_all_merged_pull_requests
    json = self.get_all_closed_pull_requests
    puts 'Check if the requests is merged'

    json.delete_if { |req|
      merged = self.is_megred(req[:number])
      if @options[:verbose]
        puts "##{req[:number]} merged #{merged}"
      end
      !merged
    }
  end

end

if __FILE__ == $0

  log_generator = LogGenerator.new({:verbose => true})

  pull_requests = log_generator.get_all_closed_pull_requests
  p pull_requests.count
  json = log_generator.get_all_merged_pull_requests
  p json.count

  # json.each { |dict|
  #   # print_json dict
  #   p "##{dict[:number]} - #{dict[:title]} (#{dict[:closed_at]})"
  # }

end