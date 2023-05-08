class Edit < Command::Base
  @@command = "edit"
  @@description = "Edit a calendar day"

  @day : Time = Time.utc

  def execute
    OptionParser.parse do |parser|
      parser.on("-d", "--day day", "day") do |day|
        @day = parse_day(day)
      end
    end

    tmp = File.tempfile("moon.md")

    File.write tmp.path, MoonApi.get_day!(@day.to_s("%d.%m.%Y"))["body"].to_s

    system "$EDITOR #{tmp.path}"

    content = tmp.gets_to_end
    parser = MarkdownParser.new content
    puts parser.to_s(true)

    puts "Saving..."
    MoonApi.save_day!(@day.to_s("%d.%m.%Y"), content)
    puts "Saved!"

    tmp.close
  end

  private def parse_day(day)
    now = Time.utc
    if day == nil
      now
    elsif /\d{2}.\d{2}.\d{4}/.match(day)
      t = Time.parse_utc(day, "%d.%m.%Y")
    elsif /\d{2}.\d{2}/.match(day)
      Time.parse_utc(day + "." + now.to_s("%Y"), "%d.%m.%Y")
    elsif /\d{2}/.match(day)
      t = Time.parse_utc(day + "." + now.to_s("%m.%Y"), "%d.%m.%Y")
    else
      raise "Invalid day format"
    end
  end
end
