require File.expand_path('../lib/active_record/zero_downtime/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'activerecord_zero_downtime'
  gem.version       = ActiveRecord::ZeroDowntime::VERSION
  gem.date          = '2015-08-10'
  gem.summary       = 'ActiveRecord migration helpers to avoid downtime'
  gem.description   = ''
  gem.authors       = ['GoCardless Engineering']
  gem.email         = 'developers@gocardless.com'
  gem.files         = `git ls-files`.split("\n")
  gem.require_paths = ['lib']
  gem.homepage      = 'https://github.com/gocardless/activerecord_zero_downtime'
  gem.license       = 'MIT'

  gem.add_runtime_dependency 'activerecord', '~> 4.2.3'
end
