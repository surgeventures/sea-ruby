module InvoicingApp
  module Analytics
    extend SignalRouter::SingleObserver

    module_function

    def get_invoice_count(customer_id)
      GetInvoiceCountService.new(customer_id).call
    end
  end
end
