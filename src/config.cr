class Config
  # state directory
  @@state = "#{ENV["HOME"]}/.local/state/polaris"

  def self.save_token(token)
    state = @@state

    Dir.mkdir(state) unless Dir.exists?(state)

    puts "Saving token to #{state}/token".colorize(:yellow)

    File.write(state + "/token", token)
  end

  def self.logged?
    File.exists?(@@state + "/token")
  end

  def self.token!
    File.read(@@state + "/token")
  end

  def self.logout
    File.delete(@@state + "/token")
  end
end
