require 'sinatra'
require 'haml'
require 'mongoid'

class DictionaryModel
  include Mongoid::Document
  field :word, type: String
  field :meaning, type: String
  index({ word: 1 }, { unique: true })
end

configure do
  #set :server, :webrick
  set :server, :thin
  set :port, 80
  Mongoid.load!("config/mongoid.yml", :development)
end

get '/' do
  @test = "This is a test"
  rc = DictionaryModel.where(word: 'Brandon')
  @dmArray=rc.entries
  puts @dmArray
  haml :index
end

=begin
itm1 = DictionaryModel.new(:word => 'w2', :meaning => 'm2')
itm1.save
=end
