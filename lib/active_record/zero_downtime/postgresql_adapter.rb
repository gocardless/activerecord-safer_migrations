module ActiveRecord
  module ZeroDowntime
    module PostgreSQLAdapter
      SET_LOCK_TIMEOUT_SQL = <<-SQL
      UPDATE
        pg_settings
      SET
        setting = ?
      WHERE
        name = 'lock_timeout'
      SQL

      GET_LOCK_TIMEOUT_SQL = <<-SQL
      SELECT
        setting AS lock_timeout
      FROM
        pg_settings
      WHERE
        name = 'lock_timeout'
      SQL

      def set_lock_timeout(milliseconds)
        execute(fill_sql_values(SET_LOCK_TIMEOUT_SQL, [milliseconds]))
      end

      def get_lock_timeout
        execute(GET_LOCK_TIMEOUT_SQL).first["lock_timeout"].to_i
      end

      private

      def fill_sql_values(sql, values)
        ActiveRecord::Base.send(:sanitize_sql_array, [sql, *values])
      end
    end
  end
end
