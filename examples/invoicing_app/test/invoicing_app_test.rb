require_relative 'test_helper'

class InvoicingAppTest < Minitest::Test
  describe "invoice creation" do
    it 'creates invoice with side-effects' do
      invoice = nil
      out, _ = capture_io do
        invoice = InvoicingApp::Sales.create_invoice(123, 456)
      end

      assert invoice.number
      assert_match "Customer 456 invoice counter increased", out
      assert_match "Customer 456 marked as active", out
      assert_match "Stock for product 123 decreased", out
    end
  end
end
