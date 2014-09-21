require 'sinatra'
require 'haml'
#require 'mongo_mapper'
require 'mongoid'
require './config/init'

class DictionaryModel
  include MongoMapper::Document
  
  key :word, String, :required => true
  key :meaning, String, :required => true
end

configure do
  set :server, :webrick
  #set :server, :thin
  set :port, 4568
  MongoMapper.setup(@config, @environment)
end

get '/' do
  @test = "This is a test"
  existing = DictionaryModel.where(:word => 'Brandon')
  @dmArray=[]
  existing.all.each{|e|dmArray << e.to_json}
  haml :index
end
