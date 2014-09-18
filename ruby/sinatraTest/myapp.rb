require 'sinatra'
require 'haml'
require 'mongo_mapper'
require './config/init'

configure do
  #set :server, :webrick
  MongoMapper.setup(@config, @environment)
  set :server, :thin
  set :port, 80
end

get '/' do
  @test = "This is a test"
  haml :index
end
