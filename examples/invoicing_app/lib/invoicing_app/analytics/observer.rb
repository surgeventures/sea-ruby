module InvoicingApp
  module Analytics
    class Observer < Sea::Observer
      def handle_signal
        if signal.is_a?(Sales::InvoiceCreatedSignal)
          if counter = Repo.get_by(CustomerInvoiceCounter, :customer_id, signal.customer_id)
            counter.invoice_count += 1
            Repo.update(counter)
          else
            counter = CustomerInvoiceCounter.new(customer_id: signal.customer_id, invoice_count: 1)
            Repo.insert(counter)
          end
        else
          raise("Unsupported signal: #{signal.inspect}")
        end
      end
    end
  end
end
