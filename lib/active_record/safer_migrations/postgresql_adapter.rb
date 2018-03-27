# frozen_string_literal: true

module ActiveRecord
  module SaferMigrations
    module PostgreSQLAdapter
      SET_SETTING_SQL = <<-SQL.
      UPDATE
        pg_settings
      SET
        setting = :value
      WHERE
        name = :setting_name
      SQL
        freeze

      GET_SETTING_SQL = <<-SQL.
      SELECT
        setting
      FROM
        pg_settings
      WHERE
        name = :setting_name
      SQL
        freeze

      def set_setting(setting_name, value)
        sql = fill_sql_values(SET_SETTING_SQL, value: value, setting_name: setting_name)
        execute(sql)
      end

      def get_setting(setting_name)
        sql = fill_sql_values(GET_SETTING_SQL, setting_name: setting_name)
        result = execute(sql)
        result.first["setting"]
      end

      def fill_sql_values(sql, values)
        ActiveRecord::Base.send(:replace_named_bind_variables, sql, values)
      end
    end
  end
end
