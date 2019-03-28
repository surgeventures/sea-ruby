module InvoicingApp
  module Customers
    class CheckActiveService
      def initialize(account_id)
        @account_id = account_id
      end

      def call
        account = Repo.get(Account, @account_id)
        account.active
      end
    end
  end
end
