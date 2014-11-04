#!/usr/bin/env ruby
# encoding: UTF-8

require_relative 'log_generator'

generator = LogGenerator.new

tag_time = generator.findPrevTagDate
pull_requests = generator.getAllClosedPullRequests

pull_requests.delete_if { |req|
  t = Time.parse(req[:closed_at]).utc
  t < tag_time
}

generator.compund_changelog(tag_time, pull_requests)