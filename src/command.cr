abstract class Command::Base
  @@command = ""
  @@description = ""

  abstract def execute

  def self.command
    @@command
  end

  def self.description
    @@description
  end
end
