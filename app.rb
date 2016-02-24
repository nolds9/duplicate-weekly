require 'httparty'
require 'sinatra'
require 'sinatra/reloader'
require_relative "env"
require 'pry'
require_relative "models/spotify"
also_reload "models/spotify.rb"
require "base64"

enable :sessions
set :session_secret, "ninja please"

BASE64_ENCODED_ID_SECRET = Base64.strict_encode64(CLIENT_ID+":"+CLIENT_SECRET)

get "/" do
  @auth_url = "https://accounts.spotify.com/authorize?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{REDIRECT_URI}&scope=playlist-modify-private"
  erb :index
end

get "/duplicate" do
  s = Spotify.new(session[:access_token])
  p s.duplicate(s.discover_weekly)
  session[:access_token]
end

get "/auth/spotify/callback" do
  body = {
    "grant_type" => 'authorization_code',
    code: params[:code],
    redirect_uri: REDIRECT_URI
  }
  res = HTTParty.post("https://accounts.spotify.com/api/token", body: body, headers: {
    "Authorization" => "Basic #{BASE64_ENCODED_ID_SECRET}",
    "Content-Type" => "application/x-www-form-urlencoded"
  })
  session[:access_token] = res["access_token"]
  redirect "/duplicate"
end
