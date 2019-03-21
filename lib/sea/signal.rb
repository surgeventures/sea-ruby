module Sea
  # Defines signal (aka. event) with payload that will get emitted to defined observers.
  class Signal
    class << self
      def emit_to(observer)
        return observer.each { |o| emit_to(o) } if observer.is_a?(Array)

        check_observer_type(observer)
        check_observer_uniqueness(observer)

        observers.push(observer)
      end

      def emit(signal)
        observers.each do |observer|
          observer = const_get(observer) if observer.is_a?(String)
          observer.handle_signal(signal)
        end
      end

      def inherited(child)
        child.emit_to(observers)
      end

      private

      def check_observer_type(arg)
        return if arg.is_a?(String) || arg.is_a?(Class) || arg.is_a?(Module)

        raise(ArgumentError, "expected observer class/module or string, got: #{arg.inspect}")
      end

      def check_observer_uniqueness(arg)
        return unless observers.include?(arg)

        raise(ArgumentError, "observer #{arg.inspect} already added")
      end

      def observers
        @observers ||= []
        @observers
      end
    end

    def emit
      self.class.emit(self)
    end
  end
end
