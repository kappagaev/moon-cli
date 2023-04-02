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
    res = Crest.post(
      "http://127.0.0.1:3000/api/signin",
      {:email => email, :password => password}
    )
    hash = Hash(String, String).from_json(res.body)
    if hash.has_key?("error")
      puts "Authentication failed"
      puts "Error: #{hash["error"]}"
      exit(1)
    elsif hash.has_key?("token")
      puts "Authentication successful"
      token = hash["token"]
      return token
    else
      puts "Unknown error"
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
