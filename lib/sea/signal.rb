module Sea
class Signal
  class << self
    def emit_to(observer)
      if observer.is_a?(Array)
        return observer.each { |o| emit_to(o) }
      end

      check_observer_type(observer)
      check_observer_uniqueness(observer)

      observers.push(observer)
    end

    def emit(signal)
      observers.each do |observer|
        observer = self.const_get(observer) if observer.is_a?(String)
        observer.handle_signal(signal)
      end
    end

    def inherited(child)
      child.emit_to(observers)
    end

    private

    def check_observer_type(o)
      unless o.is_a?(String) || o.is_a?(Class) || o.is_a?(Module)
        raise(ArgumentError, "expected observer class/module or string, got: #{o.inspect}")
      end
    end

    def check_observer_uniqueness(o)
      if observers.include?(o)
        raise(ArgumentError, "observer #{o.inspect} already added")
      end
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
