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

    puts "Edit #{@day}"

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
