class Spotify
  include HTTParty
  attr_accessor :user, :playlists

  def initialize(token)
    @headers = {
      "Authorization" => "Bearer #{token}",
      "Accept" => "application/json",
      "Content-type" => "application/json"
    }
    @user = HTTParty.get("https://api.spotify.com/v1/me", headers: @headers)
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
    # get a playlist's tracks
    tracks = HTTParty.get(url, headers: @headers)["items"]
    id = @user["id"]
    # create new playlist
    new_playlist = HTTParty.post("https://api.spotify.com/v1/users/#{id}/playlists", body: {
      name: Time.now.strftime("%Y-%m-%d"),
      public: false
    }.to_json, headers: @headers)
    new_playlist_id = new_playlist["id"]
    # store each track's uri as an array
    uris = tracks.map{|t| t["track"]["uri"]}
    # add tracks to new playlist
    added_tracks = HTTParty.post("https://api.spotify.com/v1/users/#{id}/playlists/#{new_playlist_id}/tracks", body: {
      uris: uris
    }.to_json, headers: @headers)
  end
end
