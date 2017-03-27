require "bundler/gem_tasks"
require "bundler/cli"
require 'rspec/core/rake_task'
require 'yaml'
require 'active_support'

namespace :test do
  RSpec::Core::RakeTask.new(:rspec)

  desc "Run tests against all drivers and all databases listed in the config"
  task :all do
    db_config = YAML.load_file(File.join(File.dirname(__FILE__), "spec/config.yml"))
    configs = db_config["database"].keys.product(
      %w[selenium webkit poltergeist],
      %w[active_record sequel]
    )
    configs.each do |db_name, driver, orm|
      ENV['DB'] = db_name
      ENV['DRIVER'] = driver
      ENV['ORM'] = orm
      puts ENV.to_hash.slice 'DRIVER', 'DB', 'ORM'
      Rake::Task['test:rspec'].reenable
      Rake::Task['test:rspec'].invoke
    end
  end

  desc "Run the test server for manual debugging"
  task :server do
    db_type = ENV['DB'] || 'sqlite'
    db_config = YAML.load_file(File.join(File.dirname(__FILE__), "spec/config.yml"))
    db = db_config["database"][db_type]
    require 'active_record'
    ActiveRecord::Base.establish_connection(db)
    load File.join(File.dirname(__FILE__), "spec/support/schema.rb")
    require_relative './spec/support/server'
    require_relative './spec/support/model'
    TestValue.create! content: "This is a server response"
    AjaxServer.should_return_from_ajax = true
    AjaxServer.run!
  end
end

task :bundle do
  Bundler::CLI.start(['install'])
end

if Rake::Task.task_defined? 'release:guard_clean'
  Rake::Task['release:guard_clean'].enhance [:bundle]
end
