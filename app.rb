require 'httparty'
require 'sinatra'
require 'sinatra/reloader'
require_relative "env"
require_relative "models/spotify"
also_reload "models/spotify.rb"
require "base64"

BASE64_ENCODED_ID_SECRET = Base64.encode64(CLIENT_ID+":"+CLIENT_SECRET)

get "/" do
  @auth_url = "https://accounts.spotify.com/authorize?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{REDIRECT_URI}"
  erb :index
end

get "/auth/spotify/callback" do
  body = {
    "grant_type" => 'authorization_code',
    code: params[:code],
    redirect_uri: REDIRECT_URI
  }
  p body.to_json
  res = HTTParty.post("https://accounts.spotify.com/api/token", params: body.to_json, headers: {
    "Authorization" => "Basic #{BASE64_ENCODED_ID_SECRET}",
    "Accept" => "application/json"
  })
  p res
  
end
#s = Spotify.new(SPOTIFY_TOKEN)
#s.duplicate(s.discover_weekly)
