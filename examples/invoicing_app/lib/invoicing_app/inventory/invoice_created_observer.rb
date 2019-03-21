module InvoicingApp
  module Inventory
    class InvoiceCreatedObserver < Sea::Observer
      def handle_signal
        puts "[Inventory] Stock for product #{signal.product_id} decreased"
      end
    end
  end
end
