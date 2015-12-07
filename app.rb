require 'httparty'
require 'rest-client'
require_relative "env.rb"

class Spotify
  include HTTParty
  attr_accessor :user, :playlists
  def initialize(token)
    @headers = {
      "Authorization" => "Bearer #{token}",
      "Accept" => "application/json"
    }
    response = HTTParty.get("https://api.spotify.com/v1/me", headers: @headers)
    @user = response
  end

  def playlists
    response = HTTParty.get("https://api.spotify.com/v1/me/playlists", headers: @headers)
    @playlists = response["items"]
  end

  def discover_weekly
    self.playlists.select { |playlist|
      playlist["name"] == "Discover Weekly"
    }[0]
  end
end

s = Spotify.new(SPOTIFY_TOKEN)
p s.discover_weekly
