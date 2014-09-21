require 'sinatra'
require 'haml'
require 'mongo_mapper'
require './config/init'

configure do
  #set :server, :webrick
  set :server, :thin
  set :port, 80
  MongoMapper.setup(@config, @environment)
end

get '/' do
  @test = "This is a test"
  existing = DictionaryModel.where(:word => 'Brandon')
  @dmArray=[]
  existing.all.each{|e|dmArray << e.to_json}
  haml :index
end
