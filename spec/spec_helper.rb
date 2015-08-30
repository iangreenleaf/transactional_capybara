require 'yaml'
db_type = ENV['DB'] || 'sqlite'
db_config = YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))
db = db_config["database"][db_type]

require 'active_record'
ActiveRecord::Base.establish_connection(db)
load File.join(File.dirname(__FILE__), "support/schema.rb")

require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara-webkit'

capybara_driver = ENV['DRIVER'] || 'selenium'
Capybara.javascript_driver = capybara_driver.to_sym

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.after(:each, check_result_after: true) do
    expect(find(".message").text).to eq(@expected_message)
  end
end

require 'transactional_capybara/rspec'
