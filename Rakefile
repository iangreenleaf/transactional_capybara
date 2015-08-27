require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'yaml'

namespace :test do
  RSpec::Core::RakeTask.new(:rspec)

  desc "Run tests against all databases listed in the config"
  task :all do
    db_config = YAML.load_file(File.join(File.dirname(__FILE__), "spec/config.yml"))
    db_config["database"].keys.each do |db_name|
      ENV['DB'] = db_name
      Rake::Task['test:rspec'].reenable
      Rake::Task['test:rspec'].invoke
    end
  end
end
