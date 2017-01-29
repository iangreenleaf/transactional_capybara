require 'active_record'
require_relative 'db_config'

config = db_config('active_record')
ActiveRecord::Base.establish_connection(config)
load File.join(File.dirname(__FILE__), "schema.rb")
require_relative 'model/active_record'
