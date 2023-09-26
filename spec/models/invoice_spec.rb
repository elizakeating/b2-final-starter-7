require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    it "discounted_revenue" do
      merchant_a = Merchant.create(name: "Merchant A")

      item_a = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant_a.id, status: 1)
      item_b = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: merchant_a.id, status: 1)

      bulk_discount_1 = merchant_a.bulk_discounts.create(percentage: 20, quantity_threshold: 10)
      bulk_discount_1 = merchant_a.bulk_discounts.create(percentage: 15, quantity_threshold: 15)

      customer_1 = Customer.create(first_name: "Joey", last_name: "Smith")

      invoice_a = Invoice.create(customer_id: customer_1.id, status: 2)

      invoice_item_1 = InvoiceItem.create!(invoice_id: invoice_a.id, item_id: item_a.id, quantity: 12, unit_price: 253, status: 2)
      invoice_item_2 = InvoiceItem.create!(invoice_id: invoice_a.id, item_id: item_b.id, quantity: 15, unit_price: 747, status: 2)

      expect(invoice_a.discounted_revenue).to eq(11392.8)
    end

    it "discounted_amount" do
      merchant_a = Merchant.create(name: "Merchant A")

      item_a = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant_a.id, status: 1)
      item_b = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: merchant_a.id, status: 1)

      bulk_discount_1 = merchant_a.bulk_discounts.create(percentage: 20, quantity_threshold: 10)
      bulk_discount_1 = merchant_a.bulk_discounts.create(percentage: 15, quantity_threshold: 15)

      customer_1 = Customer.create(first_name: "Joey", last_name: "Smith")

      invoice_a = Invoice.create(customer_id: customer_1.id, status: 2)

      invoice_item_1 = InvoiceItem.create!(invoice_id: invoice_a.id, item_id: item_a.id, quantity: 12, unit_price: 253, status: 2)
      invoice_item_2 = InvoiceItem.create!(invoice_id: invoice_a.id, item_id: item_b.id, quantity: 15, unit_price: 747, status: 2)

      expect(invoice_a.discounted_amount).to eq(2848.2)
    end
  end
end
