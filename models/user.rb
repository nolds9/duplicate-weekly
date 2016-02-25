
class User < ActiveRecord::Base

  def token
    body = {
      "grant_type" => 'refresh_token',
      "refresh_token" => self.refresh_token
    }
    res = HTTParty.post("https://accounts.spotify.com/api/token", body: body, headers: {
      "Authorization" => "Basic #{BASE64_ENCODED_ID_SECRET}",
      "Content-Type" => "application/x-www-form-urlencoded"
    })
  end
end
