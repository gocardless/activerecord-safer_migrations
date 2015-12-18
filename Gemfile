source "https://rubygems.org"

gemspec

gem "activerecord", "~> #{ENV['ACTIVERECORD_VERSION']}" if ENV["ACTIVERECORD_VERSION"]

group :development do
  gem "pg", "~> 0.18.3"
  gem "rspec", "~> 3.3.0"
  gem "rubocop", "~> 0.35.1"
end
