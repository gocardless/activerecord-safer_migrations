require 'active_record/connection_adapters/postgresql_adapter'
require 'active_record/safer_migrations/postgresql_adapter'
require 'active_record/safer_migrations/migration'

module ActiveRecord
  module SaferMigrations
    @default_lock_timeout = 1000

    def self.default_lock_timeout
      @default_lock_timeout
    end

    def self.default_lock_timeout=(timeout_ms)
      @default_lock_timeout = timeout_ms
    end

    def self.load
      ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
        include ActiveRecord::SaferMigrations::PostgreSQLAdapter
      end

      ActiveRecord::Migration.class_eval do
        include ActiveRecord::SaferMigrations::Migration
      end
    end
  end
end

require 'active_record/safer_migrations/railtie' if defined?(::Rails)
