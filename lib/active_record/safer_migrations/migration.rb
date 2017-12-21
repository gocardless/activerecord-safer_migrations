# frozen_string_literal: true

require "active_record/safer_migrations/setting_helper"

module ActiveRecord
  module SaferMigrations
    module Migration
      def self.included(base)
        base.class_eval do
          # Use Rails' class_attribute to get an attribute that you can
          # override in subclasses
          class_attribute :lock_timeout
          class_attribute :statement_timeout

          prepend(InstanceMethods)
          extend(ClassMethods)
        end
      end

      module InstanceMethods
        def exec_migration(conn, direction)
          # lock_timeout is an instance accessor created by class_attribute
          lock_timeout_ms = lock_timeout || SaferMigrations.default_lock_timeout
          statement_timeout_ms = statement_timeout || SaferMigrations.
            default_statement_timeout
          SettingHelper.new(conn, :lock_timeout, lock_timeout_ms).with_setting do
            SettingHelper.new(conn,
                              :statement_timeout,
                              statement_timeout_ms).with_setting do
              super(conn, direction)
            end
          end
        end
      end

      module ClassMethods
        # rubocop:disable Naming/AccessorMethodName
        def set_lock_timeout(timeout)
          # rubocop:enable Naming/AccessorMethodName
          if timeout.zero?
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

        # rubocop:disable Naming/AccessorMethodName
        def set_statement_timeout(timeout)
          # rubocop:enable Naming/AccessorMethodName
          if timeout.zero?
            raise "Setting statement_timeout to 0 is dangerous - it disables the " \
                  "statement timeout rather than instantly timing out. If you " \
                  "*actually* want to disable the statement timeout (not recommended!)" \
                  ", use the `disable_statement_timeout!` method."
          end
          self.statement_timeout = timeout
        end

        def disable_statement_timeout!
          say "WARNING: disabling the statement timeout. This is very dangerous."
          self.statement_timeout = 0
        end
      end
    end
  end
end
