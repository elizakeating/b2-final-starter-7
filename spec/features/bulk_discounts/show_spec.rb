require "rails_helper"

RSpec.describe "Merchant's Bulk Discount Show Page", type: :feature do
  before :each do 
    @merchant1 = Merchant.create!(name: "Hair Care")

    @bulk_discount1 = @merchant1.bulk_discounts.create!(percentage: 5, quantity_threshold: 5)

    visit merchant_bulk_discount_path(@merchant1, @bulk_discount1)
  end
  describe "as a merchant" do
    describe "when I visit my bulk discount show page" do
      it "I see the bulk discount's quantity threshold and percentage discount" do
        expect(page).to have_content("Percentage discount: #{@bulk_discount1.percentage}")
        expect(page).to have_content("Quantity threshold: #{@bulk_discount1.quantity_threshold}")
      end
    end
  end
end