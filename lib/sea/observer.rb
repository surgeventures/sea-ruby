module Sea
  # Defines observer capable of handling signals that will get emitted to it.
  class Observer
    class << self
      def handle_signal(signal)
        new(signal).handle_signal
      end
    end

    attr_reader :signal

    def initialize(signal)
      @signal = signal
    end

    def handle_signal
      raise(NoMethodError, "method `handle_signal' not implemented for observer #{self.class}")
    end
  end
end
