#!/usr/bin/env ruby
# encoding: UTF-8

require_relative 'log_generator'
require_relative 'parser'

def run_generator options
  generator = LogGenerator.new(options)

  prev_tag = generator.find_prev_tag

  generator.compund_changelog(prev_tag)
end

if __FILE__ == $0

  options = Parser.new.options
  run_generator(options)
end