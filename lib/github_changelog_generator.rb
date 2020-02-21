#!/usr/bin/env ruby
# frozen_string_literal: true

require "octokit"
require "faraday-http-cache"
require "logger"
require "active_support"
require "active_support/core_ext/object/blank"
require "json"
require "multi_json"
require "benchmark"

require "github_changelog_generator/helper"
require "github_changelog_generator/options"
require "github_changelog_generator/parser"
require "github_changelog_generator/parser_file"
require "github_changelog_generator/generator/generator"
require "github_changelog_generator/version"
require "github_changelog_generator/reader"

# The main module, where placed all classes (now, at least)
module GitHubChangelogGenerator
  # Main class and entry point for this script.
  class ChangelogGenerator
    # Class, responsible for whole changelog generation cycle
    # @return initialised instance of ChangelogGenerator
    def initialize
      @options = Parser.parse_options
      @generator = Generator.new @options
    end

    # The entry point of this script to generate changelog
    # @raise (ChangelogGeneratorError) Is thrown when one of specified tags was not found in list of tags.
    def run
      log = @generator.compound_changelog

      if @options.write_to_file?
        output_filename = @options[:output].to_s
        File.open(output_filename, "wb") { |file| file.write(log) }
        puts "Done!"
        puts "Generated log placed in #{Dir.pwd}/#{output_filename}"
      else
        puts log
      end
    end
  end
end
