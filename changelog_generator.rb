#!/usr/bin/env ruby
# encoding: UTF-8

require_relative 'log_generator'
require_relative 'parser'

def run_generator options
  generator = LogGenerator.new(options)

  tag_time = generator.find_prev_tag_date
  pull_requests = generator.get_all_closed_pull_requests

  pull_requests.delete_if { |req|
    t = Time.parse(req[:closed_at]).utc
    t < tag_time
  }

  generator.compund_changelog(tag_time, pull_requests)
end

if __FILE__ == $0

  options = Parser.new.options
  run_generator(options)
end