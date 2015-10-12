## ActiveRecord safer migration helpers

Once this gem is loaded, all migrations will have a `lock_timeout` set. The
default timeout is 1000 ms, but that can be easily changed (e.g. in a Rails
initializer).

```ruby
ActiveRecord::SaferMigrations.default_lock_timeout = 500
```

To explicitly set the lock timeout for a given migration, call the
`lock_timeout` class method in the migration.

```ruby
class LockTest < ActiveRecord::Migration
  lock_timeout(250)

  def change
    create_table :lock_test
  end
end
```

To disable the lock timeout for a migration, call the `disable_lock_timeout!`
class method. Note that this is [extremely dangerous][blog-post] if you're
doing any schema alterations in your migration.

```ruby
class LockTest < ActiveRecord::Migration
  # Only do this if you really know what you're doing!
  disable_lock_timeout!

  def change
    create_table :lock_test
  end
end
```

[blog-post]: https://gocardless.com/blog/zero-downtime-postgres-migrations-the-hard-parts/
