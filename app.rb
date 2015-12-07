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

  def duplicate(playlist)
    url = playlist["tracks"]["href"]

    id = @user["id"]
    # get a playlist's tracks
    tracks = HTTParty.get(url, headers: @headers)["items"]
    # p tracks
    # p "https://api.spotify.com/v1/users/#{id}/playlists/#{playlist_id}/tracks"

    new_playlist = HTTParty.post("https://api.spotify.com/v1/users/#{id}/playlists", body: {
      name: Time.now.strftime("%Y-%m-%d"),
      public: false
    }.to_json, headers: @headers)

    new_playlist_id = new_playlist["id"]
    uris = tracks.map{|t| t["track"]["uri"]}.join(",").gsub(":", "%3A")
    added_tracks = HTTParty.post("https://api.spotify.com/v1/users/#{id}/playlists/#{new_playlist_id}/tracks", body: {
      uris: uris
    }.to_json, headers: @headers, debug_output: $stdout)

    p added_tracks

  end
end

s = Spotify.new(SPOTIFY_TOKEN)
discover_weekly = s.discover_weekly
# p tracks = discover_weekly["tracks"]["href"]
 s.duplicate(discover_weekly)

# create new playlist

# for each track in s.discover_weekly

# add track to new playlist

# new method duplicate
