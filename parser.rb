require 'optparse'
class Parser

  # attr_accessor
  attr_reader :options

  def initialize
    @options = {:tag1 => nil, :tag2 => nil, :format => '%d/%m/%y'}

    parser = OptionParser.new { |opts|
      opts.banner = 'Usage: changelog_generator.rb [tag1 tag2] [-u user_name -p project_name] [options]'

      opts.on('-h', '--help', 'Displays Help') do
        puts opts
        exit
      end
      opts.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
        @options[:verbose] = v
      end
      opts.on('-l', '--last-changes', 'generate log between last 2 tags') do |last|
        @options[:last] = last
      end
      opts.on('-u', '--user [USER]', 'your username on GitHub') do |last|
        @options[:user] = last
      end
      opts.on('-p', '--project [PROJECT]', 'name of project on GitHub') do |last|
        @options[:project] = last
      end
      opts.on('-t', '--token [TOKEN]', 'your OAuth token GitHub') do |last|
        @options[:token] = last
      end
      opts.on('-f', '--date-format [FORMAT]', 'date format. default is %d/%m/%y') do |last|
        @options[:format] = last
      end
    }

    parser.parse!

    #udefined case with 1 parameter:
    if ARGV[0] && !ARGV[1]
      puts parser.banner
      exit
    end

    if !@options[:user] || !@options[:project]
      puts parser.banner
      exit
    end

    if ARGV[1]
      @options[:tag1] = ARGV[0]
      @options[:tag2] = ARGV[1]

    end

  end

end