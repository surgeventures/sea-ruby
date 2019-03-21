module InvoicingApp
  module Customers
    class InvoiceCreatedObserver < Sea::Observer
      def handle_signal
        customer = Customer.find(signal.customer_id)
        customer.active = true
        customer.save

        puts "[Customers] Customer #{customer.id} marked as active"
      end
    end
  end
end
