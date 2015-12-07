require 'httparty'
require_relative "env.rb"

class Spotify
  include HTTParty
  def initialize(token)
      headers = {
        "Authorization" => "Bearer #{token}",
        "Accept" => "application/json"
     }
      puts headers
     response = HTTParty.get("https://api.spotfiy.com/vi/me", headers: headers)
  end

end

s = Spotify.new(SPOTIFY_TOKEN)
p s
