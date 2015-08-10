module ActiveRecord
  module ZeroDowntime
    module PostgreSQLAdapter
      def set_lock_timeout(milliseconds = 1000)
        execute("SET lock_timeout = #{milliseconds}")
      end
    end
  end
end
