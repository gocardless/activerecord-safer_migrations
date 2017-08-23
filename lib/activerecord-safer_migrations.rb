# frozen_string_literal: true

require "active_record/connection_adapters/postgresql_adapter"
require "active_record/safer_migrations/postgresql_adapter"
require "active_record/safer_migrations/migration"

module ActiveRecord
  module SaferMigrations
    @default_lock_timeout = 750
    @default_statement_timeout = 1500

    def self.default_lock_timeout
      @default_lock_timeout
    end

    def self.default_lock_timeout=(timeout_ms)
      @default_lock_timeout = timeout_ms
    end

    def self.default_statement_timeout
      @default_statement_timeout
    end

    def self.default_statement_timeout=(timeout_ms)
      @default_statement_timeout = timeout_ms
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

require "active_record/safer_migrations/railtie" if defined?(::Rails)
