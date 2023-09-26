require "rails_helper"

RSpec.describe BulkDiscount, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { has_many(:invoice_items).through(:merchant) }
  end
end