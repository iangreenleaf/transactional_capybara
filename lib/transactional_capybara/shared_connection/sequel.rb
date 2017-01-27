module TransactionalCapybara
  module_function
  def share_connection
    raise 'if you want to have connection sharing with sequel just use the connection option single_threaded: true' unless Sequel::Model.db.single_threaded?
  end
end
