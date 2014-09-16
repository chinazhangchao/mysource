require 'sinatra'
require 'haml'

get '/' do
  @test = "This is a test"
  haml :index
end
