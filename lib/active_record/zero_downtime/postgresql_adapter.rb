module ActiveRecord
  module ZeroDowntime
    module PostgreSQLAdapter
      def set_lock_timeout(timeout_ms = DEFAULT_TIMEOUT_MILLIS)
        old_timeout_ms = show_lock_timeout
        execute("SET lock_timeout = #{timeout_ms}")

        if block_given?
          begin
            yield
          ensure
            execute("SET lock_timeout = #{old_timeout_ms}")
          end
        end
      end

      def show_lock_timeout
        execute('SHOW lock_timeout').first["lock_timeout"].to_i
      end
    end
  end
end
