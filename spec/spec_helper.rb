# frozen_string_literal: true

require "active_record"
require "activerecord-safer_migrations"

ActiveRecord::SaferMigrations.load
ActiveRecord::Base.establish_connection

def silence_stream(stream)
  old_stream = stream.dup
  stream.reopen(IO::NULL)
  stream.sync = true
  yield
ensure
  stream.reopen(old_stream)
  old_stream.close
end

def nuke_migrations
  ActiveRecord::Base.connection_pool.with_connection do |conn|
    conn.execute("DROP TABLE IF EXISTS schema_migrations")
  end
end

module TimeoutTestHelpers
  def self.get(timeout_name)
    sql = <<-SQL
    SELECT
      setting AS #{timeout_name}
    FROM
      pg_settings
    WHERE
      name = '#{timeout_name}'
    SQL
    ActiveRecord::Base.connection.execute(sql).first[timeout_name.to_s].to_i
  end

  def self.set(timeout_name, timeout)
    ActiveRecord::Base.connection.execute("SET #{timeout_name} = #{timeout}")
  end
end
