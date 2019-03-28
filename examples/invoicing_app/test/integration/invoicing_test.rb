require_relative '../test_helper'

class InvoicingTest < Minitest::Test
  describe "invoicing" do
    it 'create invoices for many customers until out of stock' do
      product = InvoicingApp::Inventory.create_product
      mike = InvoicingApp::Customers.register_account("Mike")
      jane = InvoicingApp::Customers.register_account("Jane")

      assert_raises Sequel::CheckConstraintViolation do
        InvoicingApp::Sales.create_invoice(product.id, mike.id)
      end

      assert_equal 0, InvoicingApp::Analytics.get_invoice_count(mike.id)

      InvoicingApp::Inventory.increase_stock(product.id, 3)

      InvoicingApp::Sales.create_invoice(product.id, mike.id)
      InvoicingApp::Sales.create_invoice(product.id, mike.id)

      assert_equal 2, InvoicingApp::Analytics.get_invoice_count(mike.id)
      assert_equal 0, InvoicingApp::Analytics.get_invoice_count(jane.id)
      assert InvoicingApp::Customers.active?(mike.id)
      refute InvoicingApp::Customers.active?(jane.id)

      InvoicingApp::Sales.create_invoice(product.id, jane.id)

      assert_equal 1, InvoicingApp::Analytics.get_invoice_count(jane.id)
      assert InvoicingApp::Customers.active?(jane.id)

      assert_raises Sequel::CheckConstraintViolation do
        InvoicingApp::Sales.create_invoice(product.id, jane.id)
      end

      assert_equal 1, InvoicingApp::Analytics.get_invoice_count(jane.id)
    end
  end
end
