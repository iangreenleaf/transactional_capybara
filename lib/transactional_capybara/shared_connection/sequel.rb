module TransactionalCapybara
  module_function
  def share_connection
    warn 'WARNING: No database connection sharing enabled! You propably want to use the sequel connection option single_threaded: true' unless Sequel::Model.db.single_threaded?
  end
end
