require 'sinatra/activerecord'
require "base64"
require 'pry'
require 'httparty'

require_relative "env"
require_relative "models/spotify"
require_relative "models/user"

BASE64_ENCODED_ID_SECRET = Base64.strict_encode64(CLIENT_ID+":"+CLIENT_SECRET)

User.all.each do |user|
  token = user.token
  s = Spotify.new token
  s.duplicate(s.discover_weekly)
end
