# frozen_string_literal: true

require File.expand_path("lib/active_record/safer_migrations/version", __dir__)

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

  gem.required_ruby_version = ">= 3.1"

  gem.add_dependency "activerecord", ">= 7.0"
  gem.metadata["rubygems_mfa_required"] = "true"
end
