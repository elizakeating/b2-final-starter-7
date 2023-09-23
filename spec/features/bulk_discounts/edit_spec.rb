require "rails_helper"

RSpec.describe "Merchant's Bulk Discount Edit", type: :feature do
  before :each do 
    @merchant1 = Merchant.create!(name: "Hair Care")

    @bulk_discount1 = @merchant1.bulk_discounts.create!(percentage: 5, quantity_threshold: 5)

    visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discount1)
  end
  describe "as a merchant" do
    describe "when I visit my bulk discount edit page" do
      describe "I see a form to edit the discount where the current attributes are pre-populated in the form" do
        describe "when I change any/all of the information and click submit" do
          it "I am redirected to the bulk discount's show page and I see that the discount's attributes have been updated" do
            expect(page).to have_field "Percentage discount:", with: "#{@bulk_discount1.percentage}"
            expect(page).to have_field "Quantity threshold:", with: "#{@bulk_discount1.quantity_threshold}"

            fill_in "Quantity threshold:", with: "3"

            click_button "Submit"

            expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}")

            expect(page).to have_content("Quantity threshold: 3")
            expect(page).not_to have_content("Quantity threshold: 5")
          end
        end
      end
    end
  end
end