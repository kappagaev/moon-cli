class MoonApi
  class LoginError < Exception
  end

  @@base_url : String = "http://127.0.0.1:3000"
  def self.login!(email, password)
    res = Crest.post(
      @@base_url + "/api/signin",
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

  def self.get_month_calendar!(month : String?) : Array(JSON::Any)
    url = month ? "/api/calendar?month=#{month}" : "/api/calendar"
    if res = get_with_auth! url
      Array(JSON::Any).from_json(res.body) || raise "Error"
    else
      raise "Error"
    end
  end

  def self.get_with_auth!(url)
    Crest.get(@@base_url + url, headers: {
      "Authorization" => Config.token!,
      "Accept" => "application/json"
    })
  end
end
