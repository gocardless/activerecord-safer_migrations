module ActiveRecord
  module ZeroDowntime
    module Migration
      def self.included(base)
        base.extend(ClassMethods)
        base.lock_timeout(:default)
      end

      module ClassMethods
        def lock_timeout(timeout)
          if timeout == 0
            raise "Setting lock_timeout to 0 is dangerous - it disables the lock " \
                  "timeout rather than instantly timing out. If you *actually* " \
                  "want to disable the lock timeout (not recommended!), use the " \
                  "`disable_lock_timeout!` method."
          end

          _set_lock_timeout(timeout)
        end

        def disable_lock_timeout!
          say "WARNING: disabling the lock timeout. This is very dangerous."
          _set_lock_timeout(0)
        end

        def _set_lock_timeout(timeout)
          unless method_defined?(:original_exec_migration)
            alias_method :original_exec_migration, :exec_migration
          end

          # Defined once on ActiveRecord::Migration when this module is included
          # (done by the Railtie) - this provides a default timeout
          #
          # Individual migrations which call `lock_timeout` or `disable_lock_timeout!`
          # will override `exec_migration` with a new timeout in the subclass
          define_method(:exec_migration) do |conn, direction|
            original_lock_timeout = conn.get_lock_timeout

            if timeout == :default
              timeout_ms = ZeroDowntime.default_lock_timeout
            else
              timeout_ms = timeout
            end

            say "set_lock_timeout(#{timeout_ms})"
            conn.set_lock_timeout(timeout_ms)

            begin
              original_exec_migration(conn, direction)
            ensure
              say "set_lock_timeout(#{original_lock_timeout})"
              conn.set_lock_timeout(original_lock_timeout)
            end
          end
        end
      end
    end
  end
end
