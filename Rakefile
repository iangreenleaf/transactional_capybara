require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'yaml'
require 'active_support'

namespace :test do
  RSpec::Core::RakeTask.new(:rspec)

  desc "Run tests against all drivers and all databases listed in the config"
  task :all do
    db_config = YAML.load_file(File.join(File.dirname(__FILE__), "spec/config.yml"))
    db_config["database"].keys.each do |db_name|
      ENV['DB'] = db_name
      %w[selenium webkit poltergeist].each do |driver|
        ENV['DRIVER'] = driver
        puts ENV.to_hash.slice 'DRIVER', 'DB'
        Rake::Task['test:rspec'].reenable
        Rake::Task['test:rspec'].invoke
      end
    end
  end
end
