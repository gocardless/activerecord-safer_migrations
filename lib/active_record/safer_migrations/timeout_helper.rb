module ActiveRecord
  module SaferMigrations
    class TimeoutHelper
      def initialize(connection, timeout)
        @connection = connection
        @timeout = timeout
      end

      # We're changing a connection level setting, and we need to make sure we return
      # it to the original value. It is automatically reverted if set within a
      # transaction which rolls back, so that case needs handling differently.
      #
      #                | In Transaction      | Not in transaction
      # ---------------------------------------------------------
      # Raises         | Reset timeout       | Reset timeout
      # Doesn't raise  | Don't reset timeout | Reset Timeout
      def with_timeout
        record_current_timeout
        set_new_timeout
        yield
        reset_timeout
      rescue
        reset_timeout unless in_transaction?
        raise
      end

      private

      def record_current_timeout
        @original_lock_timeout = @connection.get_lock_timeout
      end

      def set_new_timeout
        puts "-- set_lock_timeout(#{@timeout})"
        @connection.set_lock_timeout(@timeout)
      end

      def reset_timeout
        puts "-- set_lock_timeout(#{@original_lock_timeout})"
        @connection.set_lock_timeout(@original_lock_timeout)
      end

      def in_transaction?
        ActiveRecord::Base.connection.open_transactions > 0
      end
    end
  end
end
