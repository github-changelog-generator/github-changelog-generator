#!/usr/bin/env ruby
require 'optparse'

class Parser
  def self.parse_options
    options = {:tag1 => nil, :tag2 => nil, :format => '%d/%m/%y', :output => 'CHANGELOG.md', :labels => %w(bug enhancement), :pulls => true, :issues => true, :verbose => true, :add_issues_wo_labels => true }

    parser = OptionParser.new { |opts|
      opts.banner = 'Usage: changelog_generator [options]'
      opts.on('-u', '--user [USER]', 'Username of the owner of target GitHub repo') do |last|
        options[:user] = last
      end
      opts.on('-p', '--project [PROJECT]', 'Name of project on GitHub') do |last|
        options[:project] = last
      end
      opts.on('-t', '--token [TOKEN]', 'To make more than 50 requests this script required your OAuth token for GitHub. You can generate it on https://github.com/settings/applications') do |last|
        options[:token] = last
      end
      opts.on('-h', '--help', 'Displays Help') do
        puts opts
        exit
      end
      opts.on('-v', '--[no-]verbose', 'Run verbosely. Default is true') do |v|
        options[:verbose] = v
      end
      opts.on('--[no-]issues', 'Include closed issues to changelog. Default is true') do |v|
        options[:issues] = v
      end
      opts.on('--[no-]issues-without-labels', 'Include closed issues without any labels to changelog. Default is true') do |v|
        options[:add_issues_wo_labels] = v
      end
      opts.on('--[no-]pull-requests', 'Include pull-requests to changelog. Default is true') do |v|
        options[:pulls] = v
      end
      opts.on('-l', '--last-changes', 'Generate log between last 2 tags only') do |last|
        options[:last] = last
      end
      opts.on('-f', '--date-format [FORMAT]', 'Date format. Default is %d/%m/%y') do |last|
        options[:format] = last
      end
      opts.on('-o', '--output [NAME]', 'Output file. Default is CHANGELOG.md') do |last|
        options[:output] = last
      end
      opts.on('--labels  x,y,z', Array, 'List of labels. Issues with that labels will be included to changelog. Default is \'bug,enhancement\'') do |list|
        options[:labels] = list
      end
    }

    parser.parse!

    #udefined case with 1 parameter:
    if ARGV[0] && !ARGV[1]
      puts parser.banner
      exit
    end

    if !options[:user] && !options[:project]
      remote = `git remote -vv`.split("\n")
      match = /.*(?:[:\/])(\w*)\/((?:-|\w)*)\.git.*/.match(remote[0])

      if match[1] && match[2]
        puts "Detected user:#{match[1]}, project:#{match[2]}"
        options[:user], options[:project] = match[1], match[2]
      end
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