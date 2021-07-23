class Item < ApplicationRecord
  belongs_to :merchant, dependent: :destroy
  has_many :invoice_items, dependent: :destroy


  def self.search(search_params)
    where("name ILIKE ?", "%#{search_params}%")
  end

  def self.top_item_revenue(num)
    all
    .select("SUM (invoice_items.quantity * invoice_items.unit_price) as revenue, items.*")
    # .joins("INNER JOIN items ON merchants.id = items.merchant_id")
    .joins("INNER JOIN invoice_items ON items.id = invoice_items.item_id")
    .joins("INNER JOIN invoices ON invoices.id = invoice_items.invoice_id")
    .joins("INNER JOIN transactions ON transactions.invoice_id = invoices.id and transactions.result = 'success'")
    .group("items.id")
    .order("revenue desc")
    .limit(num)
  end
end
