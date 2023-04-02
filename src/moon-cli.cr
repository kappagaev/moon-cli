require "./command"
require "./commands/*"

require "option_parser"
require "moon-markdown"
require "crest"
require "json"

class Params
  property date : Time = Time.utc
end

params = Params.new

def default_options(parser)
  parser.on "-v", "--version", "Show version" do
    puts "version 0.1"
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


OptionParser.parse do |parser|
  default_options parser

  parser.on "login", "Login command -e=EMAIL -p=PASSWORD" do
    auth = Auth.new
    auth.execute
    exit
  end
end

def parse(body : String, date : String)
  parser = MarkdownParser.new body
  parser.parse_day("28.03.2023")
end

# Dir.open(Dir.current + "/calendar").each do |file|
# next if file == "." || file == ".." || File.directory?(file)
# date = file.gsub(".md", "")
# puts date
# body = File.read("calendar/" + file)
# puts parse(body, date).inspect
# end

