#!/usr/bin/env ruby
# encoding: UTF-8

require 'github_api'
require 'json'
require_relative 'constants'

def print_json(json)
  puts JSON.pretty_generate(json)
end

def exec_command(cmd)
  %x[cd #{@project_path} && #{cmd}]
end

def findPrevTagDate

  value1 = exec_command "git log --tags --simplify-by-decoration --pretty=\"format:%ci %d\" | grep tag"
  unless value1
    puts 'not found this tag'
    exit
  end

  scan_results = value1.scan(/.*tag.*/)

  prev_tag = scan_results[1]

  unless scan_results.count
    puts 'Not found any versions'
    exit
  end

  puts "Prev tag is #{prev_tag}"

  time = Time.parse(prev_tag)
end


def getAllClosedPullRequests

  if @oauth_token.length
    github = Github.new oauth_token: @oauth_token
  else
    github = Github.new
  end
    issues = github.pull_requests.list @github_user, @github_repo_name, :state => 'closed'
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
  log += "## [#{last_tag}] (https://github.com/#{@github_user}/#{@github_repo_name}/tree/#{last_tag})\n"

  time_string = tag_time.strftime "%Y/%m/%d"
  log += "#### #{time_string}\n"

  pull_requests.each { |dict|
    merge = "#{dict[:title]} ([\\##{dict[:number]}](https://github.com/#{@github_user}/#{@github_repo_name}/pull/#{dict[:number]}))\n"
    log += "- #{merge}"
  }

  puts log
  File.open('output.txt', 'w') { |file| file.write(log) }

end

tag_time = findPrevTagDate

pull_requests = getAllClosedPullRequests

pull_requests.delete_if { |req|
  t = Time.parse(req[:closed_at]).utc
  t < tag_time
}

compund_changelog tag_time, pull_requests