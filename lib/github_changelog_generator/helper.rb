require "logger"
module GitHubChangelogGenerator
  module Helper
    # @return true if the currently running program is a unit test
    def self.test?
      defined?SpecHelper
    end

    if test?
      @log ||= Logger.new(nil) # don't show any logs when running tests
    else
      @log ||= Logger.new(STDOUT)
    end
    @log.formatter = proc do |severity, _datetime, _progname, msg|
      string = "#{msg}\n"

      if severity == "DEBUG"
        string = string.magenta
      elsif severity == "INFO"
        string = string.white
      elsif severity == "WARN"
        string = string.yellow
      elsif severity == "ERROR"
        string = string.red
      elsif severity == "FATAL"
        string = string.red.bold
      end

      string
    end

    # Logging happens using this method
    class << self
      attr_reader :log
    end
  end
end
