class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    if !bulk_discounts.empty?
      Invoice.select("SUM((quantity * unit_price * discount)/100.0) as discounted_price").from(Invoice.joins(:bulk_discounts).select("invoice_items.*, MAX(bulk_discounts.percentage) as discount").where("invoice_items.invoice_id = ? AND invoice_items.quantity >= bulk_discounts.quantity_threshold", self.id).group("invoice_items.id"))[0].discounted_price
    else
       0
    end
  end
end
