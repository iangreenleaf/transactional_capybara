# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transactional_capybara/version'

Gem::Specification.new do |spec|
  spec.name          = "transactional_capybara"
  spec.version       = TransactionalCapybara::VERSION
  spec.authors       = ["Ian Young"]
  spec.email         = ["ian@iangreenleaf.com"]
  spec.description   = %q{Support for DB transactions with Capybara}
  spec.summary       = %q{Speed up your test suite with database transactions, without losing your mind to Capybara connection problems. Supports shared connections, plus AJAX watchers to avoid common deadlock scenarios.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capybara"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sinatra"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "mysql2"
end
