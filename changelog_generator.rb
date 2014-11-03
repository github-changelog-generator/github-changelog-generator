#!/usr/bin/env ruby
# encoding: UTF-8

require 'github_api'
require 'json'

@project_path = '/Users/petrkorolev/repo/ActionSheetPicker-3.0'

tag1 = '1.1.21'
tag2 = '1.2.0'

def print_json(json)
  puts JSON.pretty_generate(json)
end

def exec_command(cmd)
  %x[cd #{@project_path} && #{cmd}]
end

def findTagsDates(tag1, tag2)
  value1 =  exec_command "git log --tags --simplify-by-decoration --pretty=\"format:%ci %d\" | grep #{tag1}"
  unless value1
    puts 'not found this tag'
    exit
  end

  re = /(.*)\s\(.*\)/m
  match_result = re.match(value1)

  unless match_result
    puts 'Not found any versions'
    exit
  end

  time = Time.parse(match_result[1])
end

def getAllClosedPullRequests
  github = Github.new oauth_token: '8587bb22f6bf125454768a4a19dbcc774ea68d48'
  issues = github.pull_requests.list 'skywinder', 'ActionSheetPicker-3.0', :state => 'closed'
  json = issues.body

  json.each { |dict|
    # print_json dict
    # puts "##{dict[:number]} - #{dict[:title]} (#{dict[:closed_at]})"
  }

  json
end

tag_time = findTagsDates tag1, tag2

pull_requests = getAllClosedPullRequests

pull_requests.delete_if { |req|
  t = Time.parse(req[:closed_at]).utc
  t < tag_time
}

pull_requests.each { |dict|
  # print_json dict
  puts "##{dict[:number]} - #{dict[:title]} (#{dict[:closed_at]})"
}
