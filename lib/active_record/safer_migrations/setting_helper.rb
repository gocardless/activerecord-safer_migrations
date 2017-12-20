# frozen_string_literal: true

module ActiveRecord
  module SaferMigrations
    class SettingHelper
      def initialize(connection, setting_name, value)
        @connection = connection
        @setting_name = setting_name
        @value = value
      end

      # We're changing a connection level setting, and we need to make sure we return
      # it to the original value. It is automatically reverted if set within a
      # transaction which rolls back, so that case needs handling differently.
      #
      #                | In Transaction      | Not in transaction
      # ---------------------------------------------------------
      # Raises         | Reset setting       | Reset setting
      # Doesn't raise  | Don't reset setting | Reset setting
      def with_setting
        record_current_setting
        set_new_setting
        yield
        reset_setting
      rescue StandardError
        reset_setting unless in_transaction?
        raise
      end

      private

      def record_current_setting
        @original_value = @connection.get_setting(@setting_name)
      end

      def set_new_setting
        puts "-- set_setting(#{@setting_name.inspect}, #{@value})"
        @connection.set_setting(@setting_name, @value)
      end

      def reset_setting
        puts "-- set_setting(#{@setting_name.inspect}, #{@original_value})"
        @connection.set_setting(@setting_name, @original_value)
      end

      def in_transaction?
        ActiveRecord::Base.connection.open_transactions.positive?
      end
    end
  end
end
