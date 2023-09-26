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

  def discounted_amount
      Invoice.select("SUM((unit_price * quantity * discount)/100.0) as discounted_price").from(Invoice.joins(:bulk_discounts).select("invoice_items.*, MAX(bulk_discounts.percentage) as discount").where("invoice_items.invoice_id = ? AND invoice_items.quantity >= bulk_discounts.quantity_threshold", self.id).group("invoice_items.id"))[0].discounted_price
  end

  def discounted_revenue
    if discounted_amount.nil?
      total_revenue
    else
      total_revenue - discounted_amount
    end
  end
end
