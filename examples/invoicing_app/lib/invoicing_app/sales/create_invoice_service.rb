module InvoicingApp
  module Sales
    class CreateInvoiceService
      def initialize(product_id, customer_id)
        @product_id = product_id
        @customer_id = customer_id
      end

      def call
        invoice = Repo.transaction do
          invoice = Invoice.new
          invoice.generate_number
          invoice.product_id = @product_id
          invoice.customer_id = @customer_id

          invoice = Repo.insert(invoice)

          InvoiceCreatedSignal.new(invoice).emit

          invoice
        end

        invoice
      end
    end
  end
end
