module InvoicingApp
  module Inventory
    class InvoiceCreatedObserver < Sea::Observer
      def handle_signal
        IncreaseStockService.new(signal.product_id, -1).call
      end
    end
  end
end
