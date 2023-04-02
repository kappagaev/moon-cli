class MoonApi
  class LoginError < Exception
  end

  def self.login!(email, password)
    res = Crest.post(
      "http://127.0.0.1:3000/api/signin",
      {:email => email, :password => password}
    )
    hash = Hash(String, String).from_json(res.body)
    if hash.has_key?("error")
      puts "Authentication failed"
      raise LoginError.new(hash["error"])
    end

    raise LoginError.new("Unknown error") unless hash.has_key?("token")

    token = hash["token"]
    return token
  end
end
