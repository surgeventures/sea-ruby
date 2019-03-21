module InvoicingApp
  module Analytics
    class Observer < Sea::Observer
      def handle_signal
        if signal.is_a?(Sales::InvoiceCreatedSignal)
          puts "[Analytics] Customer #{signal.customer_id} invoice counter increased"
        else
          raise("Unsupported signal: #{signal.inspect}")
        end
      end
    end
  end
end
