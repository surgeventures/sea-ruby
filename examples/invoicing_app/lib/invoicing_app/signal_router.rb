module InvoicingApp
  module SignalRouter
    module SingleObserver
      def handle_signal(signal)
        observer = self.const_get("Observer")
        observer.handle_signal(signal)
      end
    end

    module OneSignalOneObserver
      def handle_signal(signal)
        observer_name = signal.class.to_s.split("::").last.sub(/Signal$/, "Observer")
        observer = self.const_get(observer_name)
        observer.handle_signal(signal)
      end
    end
  end
end
