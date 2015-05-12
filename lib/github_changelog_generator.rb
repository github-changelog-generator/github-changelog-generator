#!/usr/bin/env ruby

require "github_api"
require "json"
require "colorize"
require "benchmark"

require_relative "github_changelog_generator/parser"
require_relative "github_changelog_generator/generator"
require_relative "github_changelog_generator/version"
require_relative "github_changelog_generator/reader"
require_relative "github_changelog_generator/fetcher"

module GitHubChangelogGenerator
  # Default error for ChangelogGenerator
  class ChangelogGeneratorError < StandardError
  end

  # Main class and entry point for this script.
  class ChangelogGenerator
    attr_accessor :options, :all_tags, :github

    # Class, responsible for whole change log generation cycle
    # @return initialised instance of ChangelogGenerator
    def initialize
      @options = Parser.parse_options

      @fetcher = GitHubChangelogGenerator::Fetcher.new @options

      @generator = Generator.new @options

      # @all_tags = get_filtered_tags
      @all_tags = @fetcher.get_all_tags

      @issues, @pull_requests = @fetcher.fetch_issues_and_pull_requests

      @pull_requests = @options[:pulls] ? get_filtered_pull_requests : []

      @issues = @options[:issues] ? get_filtered_issues : []

      fetch_event_for_issues_and_pr
      detect_actual_closed_dates
    end

    # Return tags after filtering tags in lists provided by option: --between-tags & --exclude-tags
    #
    # @return [Array]
    def get_filtered_tags
      all_tags = @fetcher.get_all_tags
      filtered_tags = []
      if @options[:between_tags]
        @options[:between_tags].each do |tag|
          unless all_tags.include? tag
            puts "Warning: can't find tag #{tag}, specified with --between-tags option.".yellow
          end
        end
        filtered_tags = all_tags.select { |tag| @options[:between_tags].include? tag }
      end
      filtered_tags
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
      threads.each(&:join)

      if @options[:verbose]
        puts "Fetching closed dates for issues: Done!"
      end
    end

    # Fill :actual_date parameter of specified issue by closed date of the commit, it it was closed by commit.
    # @param [Hash] issue
    def find_closed_date_by_commit(issue)
      unless issue["events"].nil?
        # if it's PR -> then find "merged event", in case of usual issue -> fond closed date
        compare_string = issue[:merged_at].nil? ? "closed" : "merged"
        # reverse! - to find latest closed event. (event goes in date order)
        issue["events"].reverse!.each { |event|
          if event[:event].eql? compare_string
            if event[:commit_id].nil?
              issue[:actual_date] = issue[:closed_at]
            else
              begin
                commit = @fetcher.fetch_commit(event)
                issue[:actual_date] = commit[:author][:date]
              rescue
                puts "Warning: Can't fetch commit #{event[:commit_id]}. It is probably referenced from another repo.".yellow
                issue[:actual_date] = issue[:closed_at]
              end
            end
            break
          end
        }
      end
      # TODO: assert issues, that remain without 'actual_date' hash for some reason.
    end

    def print_json(json)
      puts JSON.pretty_generate(json)
    end

    # This method fetches missing params for PR and filter them by specified options
    # It include add all PR's with labels from @options[:include_labels] array
    # And exclude all from :exclude_labels array.
    # @return [Array] filtered PR's
    def get_filtered_pull_requests
      fetch_merged_at_pull_requests

      filtered_pull_requests = include_issues_by_labels(@pull_requests)

      filtered_pull_requests = exclude_issues_by_labels(filtered_pull_requests)

      if @options[:verbose]
        puts "Filtered pull requests: #{filtered_pull_requests.count}"
      end

      filtered_pull_requests
    end

    # This method fetch missing required attributes for pull requests
    # :merged_at - is a date, when issue PR was merged.
    # More correct to use this date, not closed date.
    def fetch_merged_at_pull_requests
      if @options[:verbose]
        print "Fetching merged dates...\r"
      end
      pull_requests = @fetcher.fetch_pull_requests

      @pull_requests.each { |pr|
        fetched_pr = pull_requests.find { |fpr|
          fpr.number == pr.number
        }
        pr[:merged_at] = fetched_pr[:merged_at]
        pull_requests.delete(fetched_pr)
      }

      if @options[:verbose]
        puts "Fetching merged dates: Done!"
      end
    end

    # Include issues with labels, specified in :include_labels
    # @param [Array] issues to filter
    # @return [Array] filtered array of issues
    def include_issues_by_labels(issues)
      filtered_issues = @options[:include_labels].nil? ? issues : issues.select { |issue| (issue.labels.map(&:name) & @options[:include_labels]).any? }

      if @options[:add_issues_wo_labels]
        issues_wo_labels = issues.select { |issue|
          !issue.labels.map(&:name).any?
        }
        filtered_issues |= issues_wo_labels
      end
      filtered_issues
    end

    # delete all labels with labels from @options[:exclude_labels] array
    # @param [Array] issues
    # @return [Array] filtered array
    def exclude_issues_by_labels(issues)
      unless @options[:exclude_labels].nil?
        issues = issues.select { |issue|
          !(issue.labels.map(&:name) & @options[:exclude_labels]).any?
        }
      end
      issues
    end

    # The entry point of this script to generate change log
    # @raise (ChangelogGeneratorError) Is thrown when one of specified tags was not found in list of tags.
    def compound_changelog
      log = "# Change Log\n\n"

      if @options[:unreleased_only]
        log += generate_log_between_tags(all_tags[0], nil)
      elsif @options[:tag1] and @options[:tag2]
        tag1 = @options[:tag1]
        tag2 = @options[:tag2]
        tags_strings = []
        all_tags.each { |x| tags_strings.push(x["name"]) }

        if tags_strings.include?(tag1)
          if tags_strings.include?(tag2)
            to_a = tags_strings.map.with_index.to_a
            hash = Hash[to_a]
            index1 = hash[tag1]
            index2 = hash[tag2]
            log += generate_log_between_tags(all_tags[index1], all_tags[index2])
          else
            fail ChangelogGeneratorError, "Can't find tag #{tag2} -> exit".red
          end
        else
          fail ChangelogGeneratorError, "Can't find tag #{tag1} -> exit".red
        end
      else
        log += generate_log_for_all_tags
      end

      log += "\n\n\\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*"

      output_filename = "#{@options[:output]}"
      File.open(output_filename, "w") { |file| file.write(log) }
      puts "Done!"
      puts "Generated log placed in #{`pwd`.strip!}/#{output_filename}"
    end

    # The full cycle of generation for whole project
    # @return [String] The complete change log
    def generate_log_for_all_tags
      fetch_tags_dates

      if @options[:verbose]
        puts "Sorting tags..."
      end

      @all_tags.sort_by! { |x| @fetcher.get_time_of_tag(x) }.reverse!

      if @options[:verbose]
        puts "Generating log..."
      end

      log = ""

      if @options[:unreleased] && @all_tags.count != 0
        unreleased_log = generate_log_between_tags(all_tags[0], nil)
        if unreleased_log
          log += unreleased_log
        end
      end

      (1...all_tags.size).each { |index|
        log += generate_log_between_tags(all_tags[index], all_tags[index - 1])
      }
      if @all_tags.count != 0
        log += generate_log_between_tags(nil, all_tags.last)
      end

      log
    end

    # Async fetching of all tags dates
    def fetch_tags_dates
      if @options[:verbose]
        print "Fetching tag dates...\r"
      end

      # Async fetching tags:
      threads = []
      i = 0
      all = @all_tags.count
      @all_tags.each { |tag|
        threads << Thread.new {
          @fetcher.get_time_of_tag(tag)
          if @options[:verbose]
            print "Fetching tags dates: #{i + 1}/#{all}\r"
            i += 1
          end
        }
      }

      print "                                 \r"

      threads.each(&:join)

      if @options[:verbose]
        puts "Fetching tags dates: #{i} Done!"
      end
    end

    # Generate log only between 2 specified tags
    # @param [String] older_tag all issues before this tag date will be excluded. May be nil, if it's first tag
    # @param [String] newer_tag all issue after this tag will be excluded. May be nil for unreleased section
    def generate_log_between_tags(older_tag, newer_tag)
      filtered_pull_requests = delete_by_time(@pull_requests, :actual_date, older_tag, newer_tag)
      filtered_issues = delete_by_time(@issues, :actual_date, older_tag, newer_tag)

      newer_tag_name = newer_tag.nil? ? nil : newer_tag["name"]
      older_tag_name = older_tag.nil? ? nil : older_tag["name"]

      if @options[:filter_issues_by_milestone]
        # delete excess irrelevant issues (according milestones)
        filtered_issues = filter_by_milestone(filtered_issues, newer_tag_name, @issues)
        filtered_pull_requests = filter_by_milestone(filtered_pull_requests, newer_tag_name, @pull_requests)
      end

      if filtered_issues.empty? && filtered_pull_requests.empty? && newer_tag.nil?
        # do not generate empty unreleased section
        return ""
      end

      create_log(filtered_pull_requests, filtered_issues, newer_tag, older_tag_name)
    end

    def filter_by_milestone(filtered_issues, newer_tag_name, src_array)
      filtered_issues.select! { |issue|
        # leave issues without milestones
        if issue.milestone.nil?
          true
        else
          # check, that this milestone in tag list:
          @all_tags.find { |tag| tag.name == issue.milestone.title }.nil?
        end
      }
      unless newer_tag_name.nil?

        # add missed issues (according milestones)
        issues_to_add = src_array.select { |issue|
          if issue.milestone.nil?
            false
          else
            # check, that this milestone in tag list:
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

    # Method filter issues, that belong only specified tag range
    # @param [Array] array of issues to filter
    # @param [Symbol] hash_key key of date value default is :actual_date
    # @param [String] older_tag all issues before this tag date will be excluded. May be nil, if it's first tag
    # @param [String] newer_tag all issue after this tag will be excluded. May be nil for unreleased section
    # @return [Array] filtered issues
    def delete_by_time(array, hash_key = :actual_date, older_tag = nil, newer_tag = nil)
      fail ChangelogGeneratorError, "At least one of the tags should be not nil!".red if older_tag.nil? && newer_tag.nil?

      newer_tag_time = newer_tag && @fetcher.get_time_of_tag(newer_tag)
      older_tag_time = older_tag && @fetcher.get_time_of_tag(older_tag)

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

    # Generates log for section with header and body
    #
    # @param [Array] pull_requests List or PR's in new section
    # @param [Array] issues List of issues in new section
    # @param [String] newer_tag Name of the newer tag. Could be nil for `Unreleased` section
    # @param [String] older_tag_name Older tag, used for the links. Could be nil for last tag.
    # @return [String] Ready and parsed section
    def create_log(pull_requests, issues, newer_tag, older_tag_name = nil)
      newer_tag_time = newer_tag.nil? ? Time.new : @fetcher.get_time_of_tag(newer_tag)
      if newer_tag.nil? && @options[:future_release]
        newer_tag_name = @options[:future_release]
        newer_tag_link = @options[:future_release]
      else
        newer_tag_name = newer_tag.nil? ? @options[:unreleased_label] : newer_tag["name"]
        newer_tag_link = newer_tag.nil? ? "HEAD" : newer_tag_name
      end

      github_site = options[:github_site] || "https://github.com"
      project_url = "#{github_site}/#{@options[:user]}/#{@options[:project]}"

      log = generate_header(newer_tag_name, newer_tag_link, newer_tag_time, older_tag_name, project_url)

      if @options[:issues]
        # Generate issues:
        issues_a = []
        enhancement_a = []
        bugs_a = []

        issues.each { |dict|
          added = false
          dict.labels.each { |label|
            if label.name == "bug"
              bugs_a.push dict
              added = true
              next
            end
            if label.name == "enhancement"
              enhancement_a.push dict
              added = true
              next
            end
          }
          unless added
            issues_a.push dict
          end
        }

        log += generate_sub_section(enhancement_a, @options[:enhancement_prefix])
        log += generate_sub_section(bugs_a, @options[:bug_prefix])
        log += generate_sub_section(issues_a, @options[:issue_prefix])
      end

      if @options[:pulls]
        # Generate pull requests:
        log += generate_sub_section(pull_requests, @options[:merge_prefix])
      end

      log
    end

    # @param [Array] issues List of issues on sub-section
    # @param [String] prefix Nae of sub-section
    # @return [String] Generate ready-to-go sub-section
    def generate_sub_section(issues, prefix)
      log = ""

      if options[:simple_list] != true && issues.any?
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

    # It generate one header for section with specific parameters.
    #
    # @param [String] newer_tag_name - name of newer tag
    # @param [String] newer_tag_link - used for links. Could be same as #newer_tag_name or some specific value, like HEAD
    # @param [Time] newer_tag_time - time, when newer tag created
    # @param [String] older_tag_link - tag name, used for links.
    # @param [String] project_url - url for current project.
    # @return [String] - Generate one ready-to-add section.
    def generate_header(newer_tag_name, newer_tag_link, newer_tag_time, older_tag_link, project_url)
      log = ""

      # Generate date string:
      time_string = newer_tag_time.strftime @options[:dateformat]

      # Generate tag name and link
      if newer_tag_name.equal? @options[:unreleased_label]
        log += "## [#{newer_tag_name}](#{project_url}/tree/#{newer_tag_link})\n\n"
      else
        log += "## [#{newer_tag_name}](#{project_url}/tree/#{newer_tag_link}) (#{time_string})\n\n"
      end

      if @options[:compare_link] && older_tag_link
        # Generate compare link
        log += "[Full Changelog](#{project_url}/compare/#{older_tag_link}...#{newer_tag_link})\n\n"
      end

      log
    end

    # Filter issues according labels
    # @return [Array] Filtered issues
    def get_filtered_issues
      filtered_issues = include_issues_by_labels(@issues)

      filtered_issues = exclude_issues_by_labels(filtered_issues)

      if @options[:verbose]
        puts "Filtered issues: #{filtered_issues.count}"
      end

      filtered_issues
    end

    # Fetch event for issues and pull requests
    # @return [Array] array of fetched issues
    def fetch_event_for_issues_and_pr
      if @options[:verbose]
        print "Fetching events for issues and PR: 0/#{@issues.count + @pull_requests.count}\r"
      end

      # Async fetching events:

      @fetcher.fetch_events_async(@issues + @pull_requests)
    end
  end

  if __FILE__ == $PROGRAM_NAME
    GitHubChangelogGenerator::ChangelogGenerator.new.compound_changelog
  end
end
