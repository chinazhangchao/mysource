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
  set :bind, '0.0.0.0'
  #set :port, 80
  Mongoid.load!("config/mongoid.yml", :development)
end

template :layout do
    "%html\n  =yield\n%p layout"
end

template :index do
    '%div.title Hello World!'
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

=begin
get '/hello/:name' do
  "Hello #{params[:name]}"
end
=end

get '/hello/:name' do |n|
  "Hello #{n}"
end

get '/say/*/to/*' do
  "#{params[:splat][0]}, #{params[:splat][1]}"
end

get '/download/*.*' do |path, ext|
  "#{path}, #{ext}"
end

get %r{/hl/(\w+)} do |c|
  "Hello, #{c}!"
end

get %r{/hlc/(\w+)} do
    "Hello, #{params[:captures].first}!"
end

get '/postsquery' do
  # matches "GET /posts?title=foo&author=bar"
  title = params[:title]
  author = params[:author]
  "postsquery,#{title},#{author}"
end

get '/posts.?:format?' do
  "posts #{params[:format]}"
end

get '/', :host_name => /^admin\./ do
  "管理员区域，无权进入！"
end

class Stream
  def each
    100.times { |i| yield "<p>#{i}</p>" }
  end
end

get('/s') { Stream.new }
