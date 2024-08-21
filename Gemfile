# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "activerecord", "~> #{ENV['ACTIVERECORD_VERSION']}" if ENV["ACTIVERECORD_VERSION"]

group :test, :development do
  gem "gc_ruboconfig", "~> 5.0"
  gem "pg", "~> 1.4"
  gem "rspec", "~> 3.9.0"
end
