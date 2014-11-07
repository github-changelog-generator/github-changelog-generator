#!/usr/bin/env ruby
require 'optparse'

class Parser
  def self.parse_options
    options = {:tag1 => nil, :tag2 => nil, :format => '%d/%m/%y', :output => 'CHANGELOG.md'}

    parser = OptionParser.new { |opts|
      opts.banner = 'Usage: changelog_generator --user username --project project_name [options]'
      opts.on('-u', '--user [USER]', 'Username of the owner of target GitHub repo (required)') do |last|
        options[:user] = last
      end
      opts.on('-p', '--project [PROJECT]', 'Name of project on GitHub (required)') do |last|
        options[:project] = last
      end
      opts.on('-t', '--token [TOKEN]', 'To make more than 50 requests this script required your OAuth token for GitHub. You can generate it on https://github.com/settings/applications') do |last|
        options[:token] = last
      end
      opts.on('-h', '--help', 'Displays Help') do
        puts opts
        exit
      end
      opts.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
        options[:verbose] = v
      end
      opts.on('-l', '--last-changes', 'Generate log between only last 2 tags') do |last|
        options[:last] = last
      end
      opts.on('-f', '--date-format [FORMAT]', 'Date format. Default is %d/%m/%y') do |last|
        options[:format] = last
      end
      opts.on('-o', '--output [FORMAT]', 'Output file. Default is CHANGELOG.md') do |last|
        options[:output] = last
      end
    }

    parser.parse!

    #udefined case with 1 parameter:
    if ARGV[0] && !ARGV[1]
      puts parser.banner
      exit
    end

    if !options[:user] || !options[:project]
      puts parser.banner
      exit
    end

    if ARGV[1]
      options[:tag1] = ARGV[0]
      options[:tag2] = ARGV[1]

    end

    options
  end
end