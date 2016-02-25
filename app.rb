require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'httparty'
require "base64"
require 'pry'

require_relative "env"
require_relative "models/spotify"
require_relative "models/user"
also_reload "models/spotify.rb"

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

  # grab refresh_token and store in DB
    user = Spotify.new(res["access_token"]).user
    @user = User.find_or_create_by(sid: user["id"] )
    @user.refresh_token = res["refresh_token"]
    @user.save

  redirect "/duplicate"
end
