client = MongoClient.new # defaults to localhost:27017 
db = client[‘example-db’]
coll = db[‘example-collection’]
10.times { |i| coll.insert({ :count => i+1 }) }
puts "There are #{collcoll.count} total documents. Here they are:"
coll.find.each { |doc| puts doc.inspect }
coll.update({ :count => 5 }, { :count => ‘foobar’ })
coll.remove({ :count => 8 }) coll.remove
