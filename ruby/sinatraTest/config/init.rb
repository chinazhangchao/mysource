require 'yaml'

@config = YAML.load_file("config/database.yaml")
@environment = @config["environment"]
