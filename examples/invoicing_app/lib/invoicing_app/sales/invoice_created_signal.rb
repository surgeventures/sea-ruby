module InvoicingApp
  module Sales
    class InvoiceCreatedSignal < Sea::Signal
      emit_to %w[Analytics Customers Inventory], in: "InvoicingApp"

      attr_reader :customer_id, :product_id

      def initialize(invoice)
        @customer_id = invoice.customer_id
        @product_id = invoice.product_id
      end
    end
  end
end
