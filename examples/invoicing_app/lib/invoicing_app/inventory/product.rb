module InvoicingApp
  module Inventory
    class Product < Schema
      schema "inventory_products" do
        field :stock, default: 0

        timestamps
      end
    end
  end
end
