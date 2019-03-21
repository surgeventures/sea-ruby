module InvoicingApp
  module Customers
    class Customer
      attr_accessor :id, :active, :confirmed

      def self.find(id)
        appointment = self.new
        appointment.id = id
        appointment
      end

      def save
      end
    end
  end
end
