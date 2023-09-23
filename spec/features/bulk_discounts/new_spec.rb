require "rails_helper"

RSpec.describe "New Bulk Discount", type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    
    visit "/merchants/#{@merchant1.id}/bulk_discounts/new"
  end
  describe "as a merchant" do
    describe "when I visit the new bulk discount page" do
      describe "I see a form to add a new a new bulk discount" do
        describe "I fill in the form with valid data" do
          it "I am redirected to the bulk discount index and I see my new bulk discount listed" do
            expect(page).to have_content("Percentage discount:")
            expect(page).to have_content("Quantity threshold:")

            fill_in "Percentage discount:", with: "15"
            fill_in "Quantity threshold:", with: "20"

            click_button "Submit"

            expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts")

            expect(page).to have_content("15% off orders of 20 or more items")
          end
        end
      end
    end
  end
end