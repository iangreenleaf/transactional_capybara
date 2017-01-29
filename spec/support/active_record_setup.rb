require 'yaml'
db_type = ENV['DB'] || 'sqlite'
db_config = YAML.load_file(File.join(File.dirname(__FILE__), "../config.yml"))
db = db_config["database"][db_type]

require 'active_record'
ActiveRecord::Base.establish_connection(db)
load File.join(File.dirname(__FILE__), "schema.rb")
require_relative 'model/active_record'
