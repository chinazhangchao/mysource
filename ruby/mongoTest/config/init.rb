require 'yaml'
require 'mongo_mapper'

@config = YAML.load_file("config/database.yaml")
@environment = @config["environment"]
MongoMapper.setup(@config, @environment)
