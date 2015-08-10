require 'active_record/zero_downtime/postgresql_adapter'
require 'active_record/zero_downtime/command_recorder'

module ActiveRecord
  module ZeroDowntime
    def self.load
      ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
        include ActiveRecord::ZeroDowntime::PostgreSQLAdapter
      end

      ActiveRecord::Migration::CommandRecorder.class_eval do
        include ActiveRecord::ZeroDowntime::CommandRecorder
      end
    end
  end
end

require 'active_record/zero_downtime/railtie' if defined?(::Rails)
