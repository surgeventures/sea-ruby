module InvoicingApp
  module Sales
    class Invoice < Schema
      schema "sales_invoices" do
        field :number
        field :customer_id
        field :product_id

        timestamps
      end

      def generate_number
        self.number = sprintf("%06d", rand * 1_000_000)
      end
    end
  end
end
