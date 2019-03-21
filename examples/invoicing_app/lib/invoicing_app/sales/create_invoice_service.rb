module InvoicingApp
  module Sales
    class CreateInvoiceService
      def initialize(product_id, customer_id)
        @product_id = product_id
        @customer_id = customer_id
      end

      def call
        # begin transaction

        invoice = Invoice.new
        invoice.number = sprintf("%06d", rand * 1_000_000)
        invoice.product_id = @product_id
        invoice.customer_id = @customer_id

        puts "[Sales] Invoice #{invoice.number} built"

        invoice.save

        InvoiceCreatedSignal.new(invoice).emit

        # commit transaction

        puts "[Sales] Invoice #{invoice.id} persisted along with side-effects"

        invoice
      end
    end
  end
end
