module ActiveRecord
  module ZeroDowntime
    class Railtie < Rails::Railtie
      initializer 'active_record_zero_downtime.load_adapter' do
        ActiveSupport.on_load :active_record do
          ActiveRecord::ZeroDowntime.load
        end
      end
    end
  end
end
