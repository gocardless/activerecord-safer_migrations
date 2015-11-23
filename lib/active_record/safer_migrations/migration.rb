require "active_record/safer_migrations/timeout_helper"

module ActiveRecord
  module SaferMigrations
    module Migration
      def self.included(base)
        base.class_eval do
          # Use Rails' class_attribute to get an attribute that you can
          # override in subclasses
          class_attribute :lock_timeout

          prepend(InstanceMethods)
          extend(ClassMethods)
        end
      end

      module InstanceMethods
        def exec_migration(conn, direction)
          # lock_timeout is an instance accessor created by class_attribute
          timeout_ms = lock_timeout || SaferMigrations.default_lock_timeout
          TimeoutHelper.new(conn, timeout_ms).with_timeout do
            super(conn, direction)
          end
        end
      end

      module ClassMethods
        def set_lock_timeout(timeout)
          if timeout == 0
            raise "Setting lock_timeout to 0 is dangerous - it disables the lock " \
                  "timeout rather than instantly timing out. If you *actually* " \
                  "want to disable the lock timeout (not recommended!), use the " \
                  "`disable_lock_timeout!` method."
          end
          self.lock_timeout = timeout
        end

        def disable_lock_timeout!
          say "WARNING: disabling the lock timeout. This is very dangerous."
          self.lock_timeout = 0
        end
      end
    end
  end
end
