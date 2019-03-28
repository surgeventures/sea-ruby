module InvoicingApp
  module Sales
    module_function

    def create_invoice(product_id, customer_id)
      CreateInvoiceService.new(product_id, customer_id).call
    end
  end
end
