ActiveRecord::Schema.define do
  create_table :test_values, :force => true do |t|
    t.string  :content
  end
end
