module InvoicingApp
  module Customers
    class Account < Schema
      schema "customers_accounts" do
        field :name
        field :active, default: false

        timestamps
      end
    end
  end
end
