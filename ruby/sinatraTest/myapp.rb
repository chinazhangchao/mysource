require 'sinatra'
require 'haml'

configure do
  #set :server, :webrick
  set :server, :thin
  set :port, 80
end

get '/' do
  @test = "This is a test"
  haml :index
end
