#!/usr/bin/env ruby

require "github_api"
require "json"
require "colorize"
require "benchmark"

require_relative "github_changelog_generator/helper"
require_relative "github_changelog_generator/parser"
require_relative "github_changelog_generator/parser_file"
require_relative "github_changelog_generator/generator/generator"
require_relative "github_changelog_generator/version"
require_relative "github_changelog_generator/reader"

require_relative "github_changelog_generator/slack_notifier"
require "slack-notifier"
# The main module, where placed all classes (now, at least)
module GitHubChangelogGenerator
  # Main class and entry point for this script.
  class ChangelogGenerator
    # Class, responsible for whole change log generation cycle
    # @return initialised instance of ChangelogGenerator
    def initialize
      @options = Parser.parse_options
      @generator = Generator.new @options
    end

    # The entry point of this script to generate change log
    # @raise (ChangelogGeneratorError) Is thrown when one of specified tags was not found in list of tags.
    def run
      log = @generator.compound_changelog

      output_filename = (@options[:output]).to_s
      File.open(output_filename, "w") { |file| file.write(log) }
      puts "Done!"
      puts "Generated log placed in #{Dir.pwd}/#{output_filename}"

      if @options[:slack_notifier]
        puts "Notifing Slack"
        raise "Please provide slack webhook URL." if @options[:slack_webhook_url].nil?
        SlackNotifier.ping(@options, log)
      end
    end
  end

  if __FILE__ == $PROGRAM_NAME
    GitHubChangelogGenerator::ChangelogGenerator.new.run
  end
end
