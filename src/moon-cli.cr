require "./config"
require "./api"
require "./command"
require "./commands/*"

require "./option_parser"
require "moon-markdown"
require "crest"
require "json"

macro with_commands(parser, *commands)
  {% for cmd, i in commands %}
    parser.on {{ cmd }}.command, {{ cmd }}.description do
      cmd = {{ cmd }}.new
      cmd.execute
      exit
    end
  {% end %}
end

OptionParser.parse do |parser|
  with_commands parser, Auth, Download, Edit
end


# Dir.open(Dir.current + "/calendar").each do |file|
# next if file == "." || file == ".." || File.directory?(file)
# date = file.gsub(".md", "")
# puts date
# body = File.read("calendar/" + file)
# puts parse(body, date).inspect
# end
