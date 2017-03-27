module TransactionalCapybara
  module_function
  def share_connection
    #noop is default
  end
end
if defined?(ActiveRecord::Base)
  require_relative './shared_connection/active_record'
end
if defined?(Sequel::Model)
  require_relative './shared_connection/sequel'
end
