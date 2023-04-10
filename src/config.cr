class Config
  def self.save_token(token)
    # check if dir exists
    dir = "#{ENV["HOME"]}/.config/polaris"
    Dir.mkdir(dir) unless Dir.exists?(dir)

    puts "Saving token to ~/.config/polaris/token"
    File.write(dir + "/token", token)
  end

  def self.logged?
    File.exists?("#{ENV["HOME"]}/.config/polaris/token")
  end

  def self.token!
    File.read("#{ENV["HOME"]}/.config/polaris/token")
  end

  def self.logout
    File.delete("#{ENV["HOME"]}/.config/polaris/token")
  end
end
