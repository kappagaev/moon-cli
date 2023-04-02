class Config
  def self.save_token(token)
    # check if dir exists
    dir = "#{ENV["HOME"]}/.config/polaris"
    Dir.mkdir(dir) unless Dir.exists?(dir)

    puts "Saving token to ~/.config/polaris/token"
    File.write(dir + "/token", token)
  end
end
