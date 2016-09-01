require "logger"
require "rainbow/ext/string"

module GitHubChangelogGenerator
  module Helper
    # @return true if the currently running program is a unit test
    def self.test?
      defined? SpecHelper
    end

    @log ||= if test?
               Logger.new(nil) # don't show any logs when running tests
             else
               Logger.new(STDOUT)
             end
    @log.formatter = proc do |severity, _datetime, _progname, msg|
      string = "#{msg}\n"
      case severity
      when "DEBUG" then string.color(:magenta)
      when "INFO" then string.color(:white)
      when "WARN" then string.color(:yellow)
      when "ERROR" then string.color(:red)
      when "FATAL" then string.color(:red).bright
      else string
      end
    end

    # Logging happens using this method
    class << self
      attr_reader :log
    end
  end
end
