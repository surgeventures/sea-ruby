module InvoicingApp
  module Analytics
    class CustomerInvoiceCounter < Schema
      schema "analytics_customer_invoice_counters" do
        field :customer_id
        field :invoice_count
      end
    end
  end
end
