require 'active_record'
require_relative 'db_config'

config = db_config('active_record')
ActiveRecord::Base.establish_connection(config)

ActiveRecord::Schema.define do
  create_table :test_values, :force => true do |t|
    t.string  :content
  end
end

require_relative 'model/active_record'
