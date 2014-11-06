#!/usr/bin/env ruby

require 'optparse'
require 'github_api'
require 'json'
require 'httparty'


class ChangelogGenerator

  attr_accessor :options, :all_tags

  def initialize()

    @options = self.parse_options
    if @options[:token]
      @github = Github.new oauth_token: @options[:token]
    else
      @github = Github.new
    end
    @all_tags = self.get_all_tags
    @pull_requests = self.get_all_closed_pull_requests

    @tag_times_hash = {}
  end

  def parse_options
    options = {:tag1 => nil, :tag2 => nil, :format => '%d/%m/%y'}

    parser = OptionParser.new { |opts|
      opts.banner = 'Usage: changelog_generator.rb [tag1 tag2] [-u user_name -p project_name] [options]'

      opts.on('-h', '--help', 'Displays Help') do
        puts opts
        exit
      end
      opts.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
        options[:verbose] = v
      end
      opts.on('-l', '--last-changes', 'generate log between last 2 tags') do |last|
        options[:last] = last
      end
      opts.on('-u', '--user [USER]', 'your username on GitHub') do |last|
        options[:user] = last
      end
      opts.on('-p', '--project [PROJECT]', 'name of project on GitHub') do |last|
        options[:project] = last
      end
      opts.on('-t', '--token [TOKEN]', 'your OAuth token GitHub') do |last|
        options[:token] = last
      end
      opts.on('-f', '--date-format [FORMAT]', 'date format. default is %d/%m/%y') do |last|
        options[:format] = last
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

  def print_json(json)
    puts JSON.pretty_generate(json)
  end

  def exec_command(cmd)
    exec_cmd = "cd #{$project_path} && #{cmd}"
    %x[#{exec_cmd}]
  end


  def get_all_closed_pull_requests


    issues = @github.pull_requests.list @options[:user], @options[:project], :state => 'closed'
    json = issues.body

    if @options[:verbose]
      puts 'Receive all pull requests'
    end

    json

  end

  def compund_changelog
    if @options[:verbose]
      puts 'Generating changelog:'
    end

    log = "# Changelog\n\n"

    if @options[:last]
      log += self.generate_log_between_tags(self.all_tags[0], self.all_tags[1])
    elsif @options[:tag1] && @options[:tag2]

      tag1 = @options[:tag1]
      tag2 = @options[:tag2]
      tags_strings = []
      self.all_tags.each { |x| tags_strings.push(x['name'])}

      if tags_strings.include?(tag1)
        if tags_strings.include?(tag2)
          hash = Hash[tags_strings.map.with_index.to_a]
          index1 = hash[tag1]
          index2 = hash[tag2]
          log += self.generate_log_between_tags(self.all_tags[index1], self.all_tags[index2])
        else
          puts "Can't find tag #{tag2} -> exit"
          exit
        end
      else
        puts "Can't find tag #{tag1} -> exit"
        exit
      end
    else
      log += self.generate_log_for_all_tags
    end


    if @options[:verbose]
      puts log
    end

    output_filename = "#{@options[:project]}_changelog.md"
    File.open(output_filename, 'w') { |file| file.write(log) }

    puts "Done! Generated log placed in #{output_filename}"

  end

  def generate_log_for_all_tags
    log = ''
    for index in 1 ... self.all_tags.size
      log += self.generate_log_between_tags(self.all_tags[index-1], self.all_tags[index])
    end

    log
  end

  def is_megred(number)
    @github.pull_requests.merged? @options[:user], @options[:project], number
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

    if @options[:verbose]
      puts "Receive tags for repo #{@options[:project]}"
    end

    url = "https://api.github.com/repos/#{@options[:user]}/#{@options[:project]}/tags"
    response = HTTParty.get(url,
                            :headers => {'Authorization' => 'token 8587bb22f6bf125454768a4a19dbcc774ea68d48',
                                        'User-Agent' => 'Changelog-Generator'})

    json_parse = JSON.parse(response.body)

    if @options[:verbose]
      puts "Found #{json_parse.count} tags"
    end

    json_parse
  end

  def generate_log_between_tags(since_tag, till_tag)
    since_tag_time = self.get_time_of_tag(since_tag)
    till_tag_time = self.get_time_of_tag(till_tag)

    # if we mix up tags order - lits fix it!
    if since_tag_time > till_tag_time
      since_tag, till_tag = till_tag, since_tag
      since_tag_time, till_tag_time = till_tag_time, since_tag_time
    end

    till_tag_name = till_tag['name']

    pull_requests = Array.new(@pull_requests)

    pull_requests.delete_if { |req|
      t = Time.parse(req[:closed_at]).utc
      true_classor_false_class = t > since_tag_time
      classor_false_class = t < till_tag_time

      in_range = (true_classor_false_class) && (classor_false_class)
      !in_range
    }

    self.create_log(pull_requests, till_tag_name, till_tag_time)
  end

  def create_log(pull_requests, tag_name, tag_time)

    trimmed_tag = tag_name.tr('v', '')
    log = "## [#{trimmed_tag}] (https://github.com/#{@options[:user]}/#{@options[:project]}/tree/#{tag_name})\n"

    time_string = tag_time.strftime @options[:format]
    log += "#### #{time_string}\n"

    pull_requests.each { |dict|
      merge = "#{dict[:title]} [\\##{dict[:number]}](https://github.com/#{@options[:user]}/#{@options[:project]}/pull/#{dict[:number]})\n\n"
      log += "- #{merge}"
    }
    log
  end

  def get_time_of_tag(prev_tag)

    if @tag_times_hash[prev_tag['name']]
      return @tag_times_hash[prev_tag['name']]
    end

    if @options[:verbose]
      puts "Get time for tag #{prev_tag['name']}"
    end

    github_git_data_commits_get = @github.git_data.commits.get @options[:user], @options[:project], prev_tag['commit']['sha']
    time_string = github_git_data_commits_get['committer']['date']
    Time.parse(time_string)
    @tag_times_hash[prev_tag['name']] = Time.parse(time_string)
  end

end

if __FILE__ == $0
  ChangelogGenerator.new.compund_changelog
end