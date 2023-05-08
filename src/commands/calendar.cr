class Download < Command::Base
  @@command = "download"
  @@description = "Download calendar from Moon Api"

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

    raise "No path to calendar" unless @path

    download_calendar

    puts "Calendar"
  end

  def download_calendar
    puts "Syncing calendar"

    days = MoonApi.get_month_calendar!(@month)

    progress = Channel(String).new

    spawn do
      days.each do |day|
        spawn do
          title = day["title"].to_s
          puts "Syncing #{title}"
          File.write(@path + "/" + title + ".md", day["body"].to_s)
          progress.send title
        end
      end
    end

    days.size.times do
      puts "Synced #{progress.receive}"
    end
  end

  def parse(body : String, date : String)
    parser = MarkdownParser.new body
    parser.parse_day(date)
  end

  def all_days
    # select reject
    # ends_with and end_with
    Dir.open(@path)
       .select {|f| f.ends_with? ".md" }
       .reject {|f|  f == "." || f == ".." || File.directory? f }
  end
end
