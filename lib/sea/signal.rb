module Sea
  # Defines signal (aka. event) with payload that will get emitted to defined observers.
  class Signal
    class << self
      def emit_to(observer, opts = {})
        return observer.each { |o| emit_to(o, opts) } if observer.is_a?(Array)

        if opts.key?(:in)
          namespace = opts.fetch(:in)

          unless observer.is_a?(String)
            raise(ArgumentError, "expected namespaced observer name, got: #{observer.inspect}")
          end

          unless namespace.is_a?(String)
            raise(ArgumentError, "expected namespace name, got: #{namespace.inspect}")
          end

          observer = "#{namespace}::#{observer}"
        end

        unless observer.is_a?(String) || observer.is_a?(Class) || observer.is_a?(Module)
          raise(ArgumentError, "expected observer class/module/name, got: #{observer.inspect}")
        end

        if observers.include?(observer)
          raise(ArgumentError, "observer #{observer.inspect} already added")
        end

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
