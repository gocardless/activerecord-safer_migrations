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

  gem.add_runtime_dependency "activerecord", ">= 4.0"
end
