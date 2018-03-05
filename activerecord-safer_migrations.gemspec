# frozen_string_literal: true

require File.expand_path("../lib/active_record/safer_migrations/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "activerecord-safer_migrations"
  gem.version       = ActiveRecord::SaferMigrations::VERSION
  gem.summary       = "ActiveRecord migration helpers to avoid downtime"
  gem.description   = ""
  gem.authors       = ["GoCardless Engineering"]
  gem.email         = "developers@gocardless.com"
  gem.files         = `git ls-files`.split("\n")
  gem.require_paths = ["lib"]
  gem.homepage      = "https://github.com/gocardless/activerecord-safer_migrations"
  gem.license       = "MIT"

  gem.required_ruby_version = "~> 2.2"

  gem.add_runtime_dependency "activerecord", ">= 4.0"

  gem.add_development_dependency "pg", "~> 0.21.0"
  gem.add_development_dependency "rspec", "~> 3.7.0"
  gem.add_development_dependency "rubocop", "~> 0.53.0"
end
