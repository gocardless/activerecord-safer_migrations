# frozen_string_literal: true

module ActiveRecord
  module SaferMigrations
    class Railtie < Rails::Railtie
      initializer "active_record_safer_migrations.load_adapter" do
        ActiveSupport.on_load :active_record do
          ActiveRecord::SaferMigrations.load
        end
      end
    end
  end
end
