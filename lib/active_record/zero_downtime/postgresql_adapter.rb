module ActiveRecord
  module ZeroDowntime
    module PostgreSQLAdapter
      def set_lock_timeout(milliseconds = DEFAULT_TIMEOUT_MILLIS)
        execute("SET lock_timeout = #{milliseconds}")
      end
    end
  end
end
