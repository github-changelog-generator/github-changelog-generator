#!/usr/bin/env ruby

require 'github_api'
require 'json'
require 'colorize'
require 'benchmark'

require_relative 'github_changelog_generator/parser'
require_relative 'github_changelog_generator/generator'
require_relative 'github_changelog_generator/version'

module GitHubChangelogGenerator
  class ChangelogGenerator

    attr_accessor :options, :all_tags, :github

    PER_PAGE_NUMBER = 30

    def initialize

      @options = Parser.parse_options

      fetch_github_token

      github_options = {per_page: PER_PAGE_NUMBER}
      github_options[:oauth_token] = @github_token unless @github_token.nil?
      github_options[:endpoint] = options[:github_endpoint] unless options[:github_endpoint].nil?
      github_options[:site] = options[:github_endpoint] unless options[:github_site].nil?

      @github = Github.new github_options

      @generator = Generator.new(@options)

      @all_tags = self.get_all_tags
      @issues, @pull_requests = self.fetch_issues_and_pull_requests

      if @options[:pulls]
        @pull_requests = self.get_filtered_pull_requests
      else
        @pull_requests = []
      end

      if @options[:issues]
        @issues = self.get_filtered_issues
      else
        @issues = []
      end

      fetch_event_for_issues_and_pr
      detect_actual_closed_dates
      @tag_times_hash = {}
    end

    def detect_actual_closed_dates

      if @options[:verbose]
        print "Fetching closed dates for issues...\r"
      end

      threads = []

      @issues.each { |issue|
        threads << Thread.new {
          find_closed_date_by_commit(issue)
        }
      }

      @pull_requests.each { |pull_request|
        threads << Thread.new {
          find_closed_date_by_commit(pull_request)
        }
      }
      threads.each { |thr| thr.join }

      if @options[:verbose]
        puts 'Fetching closed dates for issues: Done!'
      end
    end

    def find_closed_date_by_commit(issue)
      unless issue['events'].nil?
        #if it's PR -> then find "merged event", in case of usual issue -> fond closed date
        compare_string = issue[:merged_at].nil? ? 'closed' : 'merged'
        # reverse! - to find latest closed event. (event goes in date order)
        issue['events'].reverse!.each { |event|
          if event[:event].eql? compare_string
            if event[:commit_id].nil?
              issue[:actual_date] = issue[:closed_at]
            else
              begin
                commit = @github.git_data.commits.get @options[:user], @options[:project], event[:commit_id]
                issue[:actual_date] = commit[:author][:date]
              rescue
                puts "Warning: can't fetch commit #{event[:commit_id]} probably it referenced from another repo."
                issue[:actual_date] = issue[:closed_at]
              end
            end
            break
          end
        }
      end
      #TODO: assert issues, that remain without 'actual_date' hash for some reason.
    end

    def print_json(json)
      puts JSON.pretty_generate(json)
    end

    def fetch_merged_at_pull_requests
      if @options[:verbose]
        print "Fetching merged dates...\r"
      end
      response = @github.pull_requests.list @options[:user], @options[:project], :state => 'closed'

      pull_requests = []
      page_i = 0
      response.each_page do |page|
        page_i += PER_PAGE_NUMBER
        count_pages = response.count_pages
        print "Fetching merged dates... #{page_i}/#{count_pages * PER_PAGE_NUMBER}\r"
        pull_requests.concat(page)
      end
      print "                                                   \r"

      @pull_requests.each { |pr|
        fetched_pr = pull_requests.find { |fpr|
          fpr.number == pr.number }
        pr[:merged_at] = fetched_pr[:merged_at]
        pull_requests.delete(fetched_pr)
      }

      if @options[:verbose]
        puts 'Fetching merged dates... Done!'
      end

    end

    def get_filtered_pull_requests

      self.fetch_merged_at_pull_requests

      filtered_pull_requests = @pull_requests.select {|pr| pr[:merged_at] != nil }

      unless @options[:include_labels].nil?
        filtered_pull_requests = @pull_requests.select { |issue|
          #add all labels from @options[:incluse_labels] array
          (issue.labels.map { |label| label.name } & @options[:include_labels]).any?
        }
      end

      unless @options[:exclude_labels].nil?
        filtered_pull_requests = filtered_pull_requests.select { |issue|
          #delete all labels from @options[:exclude_labels] array
          !(issue.labels.map { |label| label.name } & @options[:exclude_labels]).any?
        }
      end

      if @options[:add_issues_wo_labels]
        issues_wo_labels = @pull_requests.select {
          # add issues without any labels
            |issue| !issue.labels.map { |label| label.name }.any?
        }
        filtered_pull_requests |= issues_wo_labels
      end


      if @options[:verbose]
        puts "Filtered pull requests: #{filtered_pull_requests.count}"
      end

      filtered_pull_requests
    end

    def compund_changelog

      log = "# Change Log\n\n"

      if @options[:unreleased_only]
        log += self.generate_log_between_tags(self.all_tags[0], nil)
      elsif @options[:tag1] and @options[:tag2]
        tag1 = @options[:tag1]
        tag2 = @options[:tag2]
        tags_strings = []
        self.all_tags.each { |x| tags_strings.push(x['name']) }

        if tags_strings.include?(tag1)
          if tags_strings.include?(tag2)
            to_a = tags_strings.map.with_index.to_a
            hash = Hash[to_a]
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

      log += "\n\n\\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*"

      output_filename = "#{@options[:output]}"
      File.open(output_filename, 'w') { |file| file.write(log) }
      puts 'Done!'
      puts "Generated log placed in #{`pwd`.strip!}/#{output_filename}"

    end

    def generate_log_for_all_tags

      fetch_tags_dates

      if @options[:verbose]
        puts "Sorting tags.."
      end

      @all_tags.sort_by! { |x| self.get_time_of_tag(x) }.reverse!

      if @options[:verbose]
        puts "Generating log.."
      end


      log = ''

      if @options[:unreleased] && @all_tags.count != 0
        unreleased_log = self.generate_log_between_tags(self.all_tags[0], nil)
        if unreleased_log
          log += unreleased_log
        end
      end

      (1 ... self.all_tags.size).each { |index|
        log += self.generate_log_between_tags(self.all_tags[index], self.all_tags[index-1])
      }
      if @all_tags.count != 0
        log += generate_log_between_tags(nil, self.all_tags.last)
      end

      log
    end

    def fetch_tags_dates
      if @options[:verbose]
        print "Fetching tags dates..\r"
      end

      # Async fetching tags:
      threads = []
      i = 0
      all = @all_tags.count
      @all_tags.each { |tag|
        # explicit set @tag_times_hash to write data safety.
        threads << Thread.new {
          self.get_time_of_tag(tag, @tag_times_hash)
          if @options[:verbose]
            print "Fetching tags dates: #{i+1}/#{all}\r"
            i+=1
          end

        }
      }

      print "                                 \r"

      threads.each { |thr| thr.join }

      if @options[:verbose]
        puts 'Fetching tags: Done!'
      end
    end

    def is_megred(number)
      @github.pull_requests.merged? @options[:user], @options[:project], number
    end

    def get_all_tags

      if @options[:verbose]
        print "Fetching tags...\r"
      end

      response = @github.repos.tags @options[:user], @options[:project]

      tags = []
      page_i = 0
      count_pages = response.count_pages
      response.each_page do |page|
        page_i += PER_PAGE_NUMBER
        print "Fetching tags... #{page_i}/#{count_pages * PER_PAGE_NUMBER}\r"
        tags.concat(page)
      end
      print "                               \r"
      if @options[:verbose]
        puts "Found #{tags.count} tags"
      end

      tags
    end

    def fetch_github_token
      env_var = @options[:token] ? @options[:token] : (ENV.fetch 'CHANGELOG_GITHUB_TOKEN', nil)

      unless env_var
        puts "Warning: No token provided (-t option) and variable $CHANGELOG_GITHUB_TOKEN was not found.".yellow
        puts "This script can make only 50 requests to GitHub API per hour without token!".yellow
      end

      @github_token ||= env_var

    end

    def generate_log_between_tags(older_tag, newer_tag)
      # older_tag nil - means it's first tag, newer_tag nil - means it unreleased section
      filtered_pull_requests = delete_by_time(@pull_requests, :actual_date, older_tag, newer_tag)
      filtered_issues = delete_by_time(@issues, :actual_date, older_tag, newer_tag)

      newer_tag_name = newer_tag.nil? ? nil : newer_tag['name']
      older_tag_name = older_tag.nil? ? nil : older_tag['name']

      if @options[:filter_issues_by_milestone]
        #delete excess irrelevant issues (according milestones)
        filtered_issues = filter_by_milestone(filtered_issues, newer_tag_name, @issues)
        filtered_pull_requests = filter_by_milestone(filtered_pull_requests, newer_tag_name, @pull_requests)
      end

      if filtered_issues.empty? && filtered_pull_requests.empty? && newer_tag.nil?
        # do not generate empty unreleased section
        return ''
      end

      self.create_log(filtered_pull_requests, filtered_issues, newer_tag, older_tag_name)
    end

    def filter_by_milestone(filtered_issues, newer_tag_name, src_array)
      filtered_issues.select! { |issue|
        # leave issues without milestones
        if issue.milestone.nil?
          true
        else
          #check, that this milestone in tag list:
          @all_tags.find { |tag| tag.name == issue.milestone.title }.nil?
        end
      }
      unless newer_tag_name.nil?

        #add missed issues (according milestones)
        issues_to_add = src_array.select { |issue|
          if issue.milestone.nil?
            false
          else
            #check, that this milestone in tag list:
            milestone_is_tag = @all_tags.find { |tag|
              tag.name == issue.milestone.title
            }

            if milestone_is_tag.nil?
              false
            else
              issue.milestone.title == newer_tag_name
            end
          end
        }

        filtered_issues |= issues_to_add
      end
      filtered_issues
    end

    def delete_by_time(array, hash_key, older_tag = nil, newer_tag = nil)

      raise 'At least one of the tags should be not nil!' if (older_tag.nil? && newer_tag.nil?)

      newer_tag_time = self.get_time_of_tag(newer_tag)
      older_tag_time = self.get_time_of_tag(older_tag)

      array.select { |req|
        if req[hash_key]
          t = Time.parse(req[hash_key]).utc

          if older_tag_time.nil?
            tag_in_range_old = true
          else
            tag_in_range_old = t > older_tag_time
          end

          if newer_tag_time.nil?
            tag_in_range_new = true
          else
            tag_in_range_new = t <= newer_tag_time
          end


          tag_in_range = (tag_in_range_old) && (tag_in_range_new)

          tag_in_range
        else
          false
        end
      }
    end

    # @param [Array] pull_requests
    # @param [Array] issues
    # @param [String] older_tag_name
    # @return [String]
    def create_log(pull_requests, issues, newer_tag, older_tag_name = nil)

      newer_tag_time = newer_tag.nil? ? nil : self.get_time_of_tag(newer_tag)
      newer_tag_name = newer_tag.nil? ? nil : newer_tag['name']

      github_site = options[:github_site] || 'https://github.com'
      project_url = "#{github_site}/#{@options[:user]}/#{@options[:project]}"

      if newer_tag.nil?
        newer_tag_name = @options[:unreleased_label]
        newer_tag_link = 'HEAD'
        newer_tag_time = Time.new
      else
        newer_tag_link = newer_tag_name
      end

      log = ''

      log += generate_header(log, newer_tag_name, newer_tag_link, newer_tag_time, older_tag_name, project_url)

      if @options[:issues]
        # Generate issues:
        issues_a = []
        enhancement_a = []
        bugs_a =[]

        issues.each { |dict|
          added = false
          dict.labels.each { |label|
            if label.name == 'bug'
              bugs_a.push dict
              added = true
              next
            end
            if label.name == 'enhancement'
              enhancement_a.push dict
              added = true
              next
            end
          }
          unless added
            issues_a.push dict
          end
        }

        log += generate_log_from_array(enhancement_a, @options[:enhancement_prefix])
        log += generate_log_from_array(bugs_a, @options[:bug_prefix])
        log += generate_log_from_array(issues_a, @options[:issue_prefix])
      end

      if @options[:pulls]
        # Generate pull requests:
        log += generate_log_from_array(pull_requests, @options[:merge_prefix])
      end

      log
    end

    def generate_log_from_array(issues, prefix)
      log = ''
      if options[:simple_list].nil? && issues.any?
        log += "#{prefix}\n\n"
      end

      if issues.any?
        issues.each { |issue|
          merge_string = @generator.get_string_for_issue(issue)
          log += "- #{merge_string}\n\n"
        }
      end
      log
    end

    def generate_header(log, newer_tag_name, newer_tag_name2, newer_tag_time, older_tag_name, project_url)

      #Generate date string:
      time_string = newer_tag_time.strftime @options[:format]

      # Generate tag name and link
      if newer_tag_name.equal? @options[:unreleased_label]
        log += "## [#{newer_tag_name}](#{project_url}/tree/#{newer_tag_name2})\n\n"
      else
        log += "## [#{newer_tag_name}](#{project_url}/tree/#{newer_tag_name2}) (#{time_string})\n\n"
      end

      if @options[:compare_link] && older_tag_name
        # Generate compare link
        log += "[Full Changelog](#{project_url}/compare/#{older_tag_name}...#{newer_tag_name2})\n\n"
      end

      log
    end

    def get_time_of_tag(tag_name, tag_times_hash = @tag_times_hash)

      if tag_name.nil?
        return nil
      end

      if tag_times_hash[tag_name['name']]
        return @tag_times_hash[tag_name['name']]
      end

      github_git_data_commits_get = @github.git_data.commits.get @options[:user], @options[:project], tag_name['commit']['sha']
      time_string = github_git_data_commits_get['committer']['date']
      @tag_times_hash[tag_name['name']] = Time.parse(time_string)
    end

    def get_filtered_issues

      issues = @issues

      filtered_issues = issues

      unless @options[:include_labels].nil?
        filtered_issues = issues.select { |issue|
          #add all labels from @options[:incluse_labels] array
          (issue.labels.map { |label| label.name } & @options[:include_labels]).any?
        }
      end

      unless @options[:exclude_labels].nil?
        filtered_issues = filtered_issues.select { |issue|
          #delete all labels from @options[:exclude_labels] array
          !(issue.labels.map { |label| label.name } & @options[:exclude_labels]).any?
        }
      end

      if @options[:add_issues_wo_labels]
        issues_wo_labels = issues.select {
          # add issues without any labels
            |issue| !issue.labels.map { |label| label.name }.any?
        }
        filtered_issues |= issues_wo_labels
      end


      if @options[:verbose]
        puts "Filtered issues: #{filtered_issues.count}"
      end

      filtered_issues

    end

    def fetch_issues_and_pull_requests
      if @options[:verbose]
        print "Fetching closed issues...\r"
      end

      response = @github.issues.list user: @options[:user], repo: @options[:project], state: 'closed', filter: 'all', labels: nil

      issues = []
      page_i = 0
      count_pages = response.count_pages
      response.each_page do |page|
        page_i += PER_PAGE_NUMBER
        print "Fetching issues... #{page_i}/#{count_pages * PER_PAGE_NUMBER}\r"
        issues.concat(page)
      end

      print "                               \r"

      if @options[:verbose]
        puts "Received issues: #{issues.count}"
      end

      # remove pull request from issues:
      issues_wo_pr = issues.select { |x|
        x.pull_request == nil
      }
      pull_requests = issues.select { |x|
        x.pull_request != nil
      }
      return issues_wo_pr, pull_requests
    end

    def fetch_event_for_issues_and_pr
      if @options[:verbose]
        print "Fetching events for issues and PR: 0/#{@issues.count + @pull_requests.count}\r"
      end

      # Async fetching events:

      fetch_events_async(@issues + @pull_requests)

      #to clear line from prev print
      print "                                                            \r"

      if @options[:verbose]
        puts 'Fetching events for issues and PR: Done!'
      end
    end

    def fetch_events_async(issues)
      i = 0
      max_thread_number = 50
      threads = []
      issues.each_slice(max_thread_number) { |issues_slice|
        issues_slice.each { |issue|
          threads << Thread.new {
            obj = @github.issues.events.list user: @options[:user], repo: @options[:project], issue_number: issue['number']
            issue[:events] = obj.body
            print "Fetching events for issues and PR: #{i+1}/#{@issues.count + @pull_requests.count}\r"
            i +=1
          }
        }
        threads.each { |thr| thr.join }
        threads = []
      }
    end

  end

  if __FILE__ == $0
    GitHubChangelogGenerator::ChangelogGenerator.new.compund_changelog
  end

end
