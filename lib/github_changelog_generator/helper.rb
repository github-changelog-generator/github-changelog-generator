# frozen_string_literal: true
require "logger"
require "rainbow"

module GitHubChangelogGenerator
  module Helper
    # @return true if the currently running program is a unit test
    def self.test?
      defined? SpecHelper
    end

    # :nocov:
    @log ||= if test?
               Logger.new(nil) # don't show any logs when running tests
             else
               Logger.new(STDOUT)
             end
    @log.formatter = proc do |severity, _datetime, _progname, msg|
      string = "#{msg}\n"
      case severity
      when "DEBUG" then Rainbow(string).magenta
      when "INFO" then Rainbow(string).white
      when "WARN" then Rainbow(string).yellow
      when "ERROR" then Rainbow(string).red
      when "FATAL" then Rainbow(string).red.bright
      else string
      end
    end
    # :nocov:

    # Logging happens using this method
    class << self
      attr_reader :log
    end
  end
end
