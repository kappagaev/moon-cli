class Auth < Command::Base
  @@command = "login"
  @@description = "Authenticate with Polaris"

  property email : String = ""
  property password : String = ""

  def execute
    token = get_token
    Config.save_token token
  end

  private def get_token
    OptionParser.parse do |parser|
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
      puts "Authentication successful"
      token
    rescue e
      puts "Error: #{e.message}"
      exit(1)
    end
  end
end
