module InvoicingApp
  module Customers
    class RegisterAccountService
      def initialize(name)
        @name = name
      end

      def call
        account = Account.new
        account.name = @name

        Repo.insert(account)
      end
    end
  end
end
