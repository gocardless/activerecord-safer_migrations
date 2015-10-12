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

module LockTestHelpers
  def self.get_timeout
    sql = <<-SQL
    SELECT
      setting AS lock_timeout
    FROM
      pg_settings
    WHERE
      name = 'lock_timeout'
    SQL
    ActiveRecord::Base.connection.execute(sql).first["lock_timeout"].to_i
  end

  def self.set_timeout(timeout)
    ActiveRecord::Base.connection.execute("SET lock_timeout = #{timeout}")
  end
end
