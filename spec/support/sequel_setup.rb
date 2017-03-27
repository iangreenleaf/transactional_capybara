require 'sequel'
require_relative 'db_config'

config = db_config('sequel').merge(single_threaded: true)
db = Sequel.connect(config)

db.create_table! :test_values do
  primary_key :id
  String :content
end
require_relative 'model/sequel'
