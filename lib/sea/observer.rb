module Sea
class Observer
  attr_reader :signal

  def initialize(signal)
    @signal = signal
  end
end
end
