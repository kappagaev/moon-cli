class Auth < Command::Base
  @@command = "login"
  @@description = "Authenticate with Polaris"

  property email : String = ""
  property password : String = ""

  def execute
    token = get_token
    save_token token
  end

  private def get_token
    OptionParser.parse do |parser|
      default_options parser

      parser.on("-e", "--email EMAIL", "Email") do |email|
        @email = email
      end

      parser.on("-p", "--password PASSWORD", "Password") do |password|
        @password = password
      end
    end

    if @email.empty? || @password.empty?
      puts "Email and password are required"
      exit(1)
    end

    puts "Authenticating..."
    begin
      token = MoonApi.login! email, password
    rescue e
      puts "Error: #{e.message}"
      exit(1)
    end
  end

  private def save_token(token)
    # check if dir exists
    dir = "#{ENV["HOME"]}/.config/polaris"
    Dir.mkdir(dir) unless Dir.exists?(dir)

    puts "Saving token to ~/.config/polaris/token"
    File.write(dir + "/token", token)
  end
end
