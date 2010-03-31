require File.dirname(__FILE__) + "/../pants.rb"

set :run, false
set :env, ENV['APP_ENV'] || :production
set :port, 4577

run Pants.application
