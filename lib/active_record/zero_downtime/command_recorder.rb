module ActiveRecord
  module ZeroDowntime
    module CommandRecorder
      def set_lock_timeout(timeout_ms = DEFAULT_TIMEOUT_MILLIS)
        old_timeout_ms = show_lock_timeout

        record(:set_lock_timeout, [old_timeout_ms])
        yield
        record(:set_lock_timeout, [timeout_ms])
      end

      def invert_set_lock_timeout(args)
        [:set_lock_timeout, args]
      end

      def show_lock_timeout
        result = ActiveRecord::Base.connection.execute('SHOW lock_timeout')
        result.first["lock_timeout"].to_i
      end
    end
  end
end
