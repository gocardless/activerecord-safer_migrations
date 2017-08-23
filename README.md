## ActiveRecord safer migration helpers

> Looking for Rails 4.0 or Ruby 2.0 support? Please check out the [1.x tree](https://github.com/gocardless/activerecord-safer_migrations/tree/v1.0.0).

*Note: this library only supports PostgreSQL 9.3+. If you're interested in adding support for other databases, we're open to pull requests!*

Postgres holds ACCESS EXCLUSIVE locks for [almost all][pg-alter-table] DDL
operations. ACCESS EXCLUSIVE locks conflict with all other table-level locks,
which can cause issues in several situations. For instance:

1. If the lock is held for a long time, all other access to the table will be
   blocked, which can result in downtime.
2. Even if the lock is only held briefly, it will block all other access to the
   table while it is in the lock queue, as it conflicts with all other locks.
   The lock can't be acquired until all other queries ahead of it have finished,
   so having to wait on long-running queries can also result in downtime.
   See [here][blog-post] for more details.

Both these issues can be avoided by setting timeouts on the migration connection -
`statement_timeout` and `lock_timeout` respectively.

Once this gem is loaded, all migrations will automatically have a
`lock_timeout` and a `statement_timeout` set. The initial `lock_timeout`
default is 750ms, and the initial `statement_timeout` default is 1500ms. Both
defaults can be easily changed (e.g. in a Rails initializer).

```ruby
ActiveRecord::SaferMigrations.default_lock_timeout = 1000
ActiveRecord::SaferMigrations.default_statement_timeout = 2000
```

To explicitly set timeouts for a given migration, use the `set_lock_timeout` and
`set_statement_timeout` class methods in the migration.

```ruby
class LockTest < ActiveRecord::Migration
  set_lock_timeout(250)
  set_statement_timeout(750)

  def change
    create_table :lock_test
  end
end
```

To disable timeouts for a migration, use the `disable_lock_timeout!` and
`disable_statement_timeout!` class methods. Note that this is [extremely
dangerous][blog-post] if you're doing any schema alterations in your migration.

```ruby
class LockTest < ActiveRecord::Migration
  # Only do this if you really know what you're doing!
  disable_lock_timeout!
  disable_statement_timeout!

  def change
    create_table :lock_test
  end
end
```

### Use with PgBouncer

This gem sets session-level settings on Postgres connections. If you're using
PgBouncer in transaction pooling mode, using session-level settings is
dangerous, as you can't guarantee which connection will receive the setting.
For this reason, this gem is incompatible with transaction-pooling and should
only be used if migrations are run on connections that support session-level
features.

[blog-post]: https://gocardless.com/blog/zero-downtime-postgres-migrations-the-hard-parts/
[pg-alter-table]: http://www.postgresql.org/docs/9.4/static/sql-altertable.html

