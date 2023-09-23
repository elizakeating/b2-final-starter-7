require "rails_helper"

RSpec.describe "Merchant Bulk Discounts Index" do
  before :each do 
    @merchant1 = Merchant.create!(name: "Hair Care")

    @bulk_discount1 = @merchant1.bulk_discounts.create!(percentage: 5, quantity_threshold: 5)
    @bulk_discount2 = @merchant1.bulk_discounts.create!(percentage: 15, quantity_threshold: 20)
  end
  describe "as a merchant" do
    describe "when I visit my bulk discounts index page" do
      it "I see all of my bulk discounts including their percentage discount and quantity thresholds and each bulk discount listed includes a link to its show page" do
        visit merchant_bulk_discounts_path(@merchant1)

        expect(page).to have_content("Bulk Discounts")
        expect(page).to have_link("5% off orders of 5 or more items")
        expect(page).to have_link("15% off orders of 20 or more items")

        click_link("5% off orders of 5 or more items")

        expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}")
      end
    end
  end
end