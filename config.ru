require './app'

set :environment, :production

run Sinatra::Application

require 'resque/server'

run Rack::URLMap.new \
  "/" => Sinatra::Application,
  "/resque" => Resque::Server.new
