module InvoicingApp
  module Customers
    class InvoiceCreatedObserver < Sea::Observer
      def handle_signal
        customer = Repo.get(Account, signal.customer_id)
        customer.active = true
        Repo.update(customer)
      end
    end
  end
end
