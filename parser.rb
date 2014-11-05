require 'optparse'
class Parser

  # attr_accessor
  attr_reader :options

  def initialize
    @options = {:tag1 => nil, :tag2 => nil}

    parser = OptionParser.new { |opts|
      opts.banner = 'Usage: changelog_generator.rb [tag1 tag2] [options]'

      opts.on('-h', '--help', 'Displays Help') do
        puts opts
        exit
      end

      opts.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
        @options[:verbose] = v
      end
    }

    parser.parse!

    #udefined case with 1 parameter:
    if ARGV[0] && !ARGV[1]
      puts parser.banner
      exit
    end

    if ARGV[1]
      @options[:tag1] = ARGV[0]
      @options[:tag2] = ARGV[1]

    end

  end

end