module InvoicingApp
  module Inventory
    class CreateProductService
      def call
        product = Product.new

        Repo.insert(product)
      end
    end
  end
end
