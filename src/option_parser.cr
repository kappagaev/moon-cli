require "option_parser"

def default_options(parser)
  parser.on "-v", "--version", "Show version" do
    puts "version 1"
    exit
  end

  parser.banner = "Usage: polaris [subcommand] [options]"

  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end

  parser.missing_option do |option_flag|
    STDERR.puts "ERROR: #{option_flag} is missing something."
    STDERR.puts ""
    STDERR.puts parser
    exit(1)
  end

  parser.invalid_option do |option_flag|
    STDERR.puts "ERROR: #{option_flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

class OptionParser
  def self.parse(args = ARGV, *, gnu_optional_args : Bool = false) : self
    parser = OptionParser.new(gnu_optional_args: gnu_optional_args)
    yield parser
    default_options parser
    parser.parse(args)
    parser
  end
end
