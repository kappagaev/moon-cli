class Calendar < Command::Base
  @@command = "calendar"
  @@description = "Authenticate with Polaris"

  property path : String = "#{ENV["HOME"]}/calendar"
  property sync : Bool = false

  # @TODO
  # property date : String = Time.utc.strftime("%M.%Y")
  property month : String = Time.utc.to_s("%m.%Y")

  def execute
    user =
    OptionParser.parse do |parser|
      parser.on("-p", "--path-to-calendar path", "path") do |path|
        @path = path
      end

      parser.on("-s", "--sync", "sync") do
        @sync = true
      end

      parser.on("-m", "--month month", "month") do |month|
        if month =~ /\d{2}/
          month = "#{month}.#{Time.utc.year}}"
        elsif month =~ /\d{2}\.\d{4}/
          month = "#{month}"
        else
          raise "Invalid month format, use MM.YYYY or MM"
        end

        @month = month
      end
    end

    if @sync
      sync_calendar
    else
      parse_calendar
    end

    puts "Calendar"
  end

  def sync_calendar
    puts MoonApi.get_month_calendar(@month).to_json
    # MoonApi.get_month_calendar("06.2023").each do |day|
    # puts day.inspect
    # end
  end

  def parse_calendar
    markdown_ch = Channel(Markdown::Page::Day).new
    context = Channel(Bool).new
    days = all_days

    spawn do
      days.each do |day|
        spawn do
          date = day.gsub(".md", "")
          body = File.read("calendar/" + day)
          markdown_ch.send parse(body, date)
        end
      end
    end

    days.size.times do
      markdown = markdown_ch.receive
      puts markdown.inspect
    end
  end

  def parse(body : String, date : String)
    parser = MarkdownParser.new body
    parser.parse_day(date)
  end

  def all_days
    # select reject
    Dir.open(@path).reject {|f|  f == "." || f == ".." || File.directory? f }
  end
end
