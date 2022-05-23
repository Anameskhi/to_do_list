ENV['SINATRA_ENV'] ||= "development"
APP_ENV = ENV["RACK_ENV"] ||= "development"

require 'require_all'
require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

require_rel '../app'