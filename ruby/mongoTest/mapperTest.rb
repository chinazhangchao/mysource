require './config/init.rb'

class DictionaryModel
  include MongoMapper::Document
  
  key :word, String, :required => true
  key :meaning, String, :required => true
end

=begin
MongoMapper.connection = Mongo::Connection.new("localhost", 27017)
MongoMapper.database = "dm"

MongoMapper.connection.connect
=end

DictionaryModel.ensure_index [[:word, 1]], :unique => true

itm1 = DictionaryModel.new(:word => 'w2', :meaning => 'm2')
itm1.save
existing = DictionaryModel.where(:word => 'Brandon')
existing.all.each{|e| puts e.to_json}
