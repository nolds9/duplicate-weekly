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

BASE64_ENCODED_ID_SECRET = Base64.strict_encode64(CLIENT_ID+":"+CLIENT_SECRET)

binding.pry

puts "fixes pry bug"
