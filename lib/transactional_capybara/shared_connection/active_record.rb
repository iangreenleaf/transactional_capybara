class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

module TransactionalCapybara
  module_function
  def share_connection
    ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
  end
end
