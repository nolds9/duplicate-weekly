require 'httparty'
require 'rest-client'
require_relative "env.rb"

class Spotify
  # include HTTParty
  def initialize(token)
      headers = {
        "Authorization" => "Bearer #{token}",
        "Accept" => "application/json"
     }
      puts headers
     response = RestClient.get("https://api.spotfiy.com/vi/me")
  end

end

s = Spotify.new(SPOTIFY_TOKEN)
p s
