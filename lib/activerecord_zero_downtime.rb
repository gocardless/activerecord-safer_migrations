require 'active_record/connection_adapters/postgresql_adapter'
require 'active_record/zero_downtime/postgresql_adapter'
require 'active_record/zero_downtime/migration'

module ActiveRecord
  module ZeroDowntime
    @default_lock_timeout = 1000

    def self.default_lock_timeout
      @default_lock_timeout
    end

    def self.default_lock_timeout=(timeout_ms)
      @default_lock_timeout = timeout_ms
    end

    def self.load
      ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
        include ActiveRecord::ZeroDowntime::PostgreSQLAdapter
      end

      ActiveRecord::Migration.class_eval do
        include ActiveRecord::ZeroDowntime::Migration
      end
    end
  end
end

require 'active_record/zero_downtime/railtie' if defined?(::Rails)
