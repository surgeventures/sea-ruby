module Sea
class Signal
  class << self
    def emit_to(observer)
      if observer.is_a?(Array)
        return observer.each { |it_observer| emit_to(it_observer) }
      end

      check_observer_type(observer)
      check_observer_uniqueness(observer)

      observers.push(observer)
    end

    def emit_within(prefix)
      if prefix.is_a?(Array)
        return prefix.each { |it_prefix| emit_within(it_prefix) }
      end

      check_prefix_type(prefix)

      suffix = self.to_s.split("::").last.sub(/Signal$/, "Observer")
      emit_to("#{prefix}::#{suffix}")
    end

    def remove_observer(observer)
      check_observer_type(observer)

      observers.delete(observer)
    end

    def emit(signal)
      observers.each do |observer|
        observer_class = self.const_get(observer)
        observer_instance = observer_class.new(signal)
        observer_instance.call
      end
    end

    private

    def check_observer_type(observer)
      unless observer.is_a?(String)
        raise(ArgumentError, "expected observer class name, got: #{observer.inspect}")
      end
    end

    def check_prefix_type(prefix)
      unless prefix.is_a?(String)
        raise(ArgumentError, "expected module name, got: #{observer.inspect}")
      end
    end

    def check_observer_uniqueness(observer)
      if observers.include?(observer)
        raise(ArgumentError, "observer #{observer} already added")
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
