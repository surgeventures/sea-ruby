module InvoicingApp
  module Analytics
    class GetInvoiceCountService
      def initialize(customer_id)
        @customer_id = customer_id
      end

      def call
        counter = Repo.get_by(CustomerInvoiceCounter, :customer_id, @customer_id)

        if counter
          counter.invoice_count
        else
          0
        end
      end
    end
  end
end
