module ActiveRecord
  module ZeroDowntime
    module CommandRecorder
      def set_lock_timeout(*args)
        milliseconds = args.first
        milliseconds ||= 1000
        record(:set_lock_timeout, milliseconds)
      end

      def invert_set_lock_timeout(args)
        [:set_lock_timeout, args]
      end
    end
  end
end
