module InvoicingApp
  module Inventory
    class IncreaseStockService
      def initialize(product_id, amount)
        @product_id = product_id
        @amount = amount
      end

      def call
        product = Repo.get(Product, @product_id)
        return unless product

        Repo.inc(product, :stock, @amount)
        product.stock += @amount
        product
      end
    end
  end
end
