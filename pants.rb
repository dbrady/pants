require 'rubygems'
require 'sinatra'
require 'dm-core'

$: << File.join(File.dirname(__FILE__), 'lib')
require 'pants/models'
#require 'pants/calendar_helper'

$0 = __FILE__

error do
  e = request.env['pants.error']
  puts "#{e.class}: #{e.message}\n#{e.backtrace.join("\n  ")}"
end

configure do
  require File.dirname(__FILE__) + '/config/pants.rb'
end

get '/' do
  "<h1>Welcome to my Pants.</h1><p>...it's not like it sounds</p><p>...not entirely, anyway</p>"
#   @recent_users  = Heartmindcode::User.best_current_streak
#   @alltime_users = Heartmindcode::User.best_alltime_streak
#   haml :index
end
