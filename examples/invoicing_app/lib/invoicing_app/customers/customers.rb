module InvoicingApp
  module Customers
    extend SignalRouter::OneSignalOneObserver

    module_function

    def active?(account_id)
      CheckActiveService.new(account_id).call
    end

    def register_account(name)
      RegisterAccountService.new(name).call
    end
  end
end
