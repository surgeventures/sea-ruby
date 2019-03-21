module InvoicingApp
  module Sales
    class Invoice
      attr_accessor :id, :number, :customer_id, :product_id

      def save
        self.id = (rand * 1000 + 1).round
      end
    end
  end
end
