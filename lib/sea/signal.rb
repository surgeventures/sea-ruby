module Sea
  # Defines signal (aka. event) with payload that will get emitted to defined observers.
  class Signal
    class << self
      def emit_to(observer, opts = {})
        return observer.each { |o| emit_to(o, opts) } if observer.is_a?(Array)

        if opts.key?(:in)
          namespace = opts.fetch(:in)
          validate_observer_with_namespace(observer, namespace)
          observer = "#{namespace}::#{observer}"
        end

        validate_observer(observer)
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

      def validate_observer_with_namespace(observer, namespace)
        unless observer.is_a?(String)
          raise(ArgumentError, "expected namespaced observer name, got: #{observer.inspect}")
        end

        unless namespace.is_a?(String)
          raise(ArgumentError, "expected namespace name, got: #{namespace.inspect}")
        end

        true
      end

      def validate_observer(observer)
        unless observer.is_a?(String) || observer.is_a?(Class) || observer.is_a?(Module)
          raise(ArgumentError, "expected observer class/module/name, got: #{observer.inspect}")
        end

        if observers.include?(observer)
          raise(ArgumentError, "observer #{observer.inspect} already added")
        end

        true
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
