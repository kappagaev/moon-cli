
class MarkdownParser
  def to_s(print_day = true)
    if t = title
      return String.build do |s|
        s << "# #{title}\n\n".colorize(:green)
        tags.each do |tag|
          s << "##{tag}".colorize(:light_red)
        end
        s << "\n\n"
        parse_day(t).events.each do |e|
          s << e.to_s
        end
      end
    else
      raise "No title found"
    end
  end
end

struct Markdown::Event
  def to_s
    String.build do |s|
      s << "- "
      time = String.build do |st|
        st << "#{start_at.try &.to_s("%H:%M")}".colorize(:light_yellow)
        if ends = end_at
          st << " - "
          st << "#{ends.to_s("%H:%M")}".colorize(:yellow)
        end
      end
      s << time.ljust(22)
      s << " #{title} ".colorize(:light_blue)
      s << "\n"
      s << "  #{description}\n"
    end
  end
end
