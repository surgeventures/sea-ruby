module InvoicingApp
  module Inventory
    extend SignalRouter::OneSignalOneObserver

    module_function

    def create_product
      CreateProductService.new.call
    end

    def increase_stock(product_id, amount = 1)
      IncreaseStockService.new(product_id, amount).call
    end
  end
end
