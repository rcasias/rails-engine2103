class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices
  has_many :invoice_items, through: :items

  def self.items_merchant(id)
    joins(:items).select('merchants.*', 'items.merchant_id', 'items.id as item_id')
    .where('items.id = ?', id)
  end

  def self.search(search_params)
    where("name ILIKE ?", "%#{search_params}%").order(:name).first
  end

  def self.most_items_sold(num)
    all
    .select("sum (invoice_items.quantity) as count, merchants.*")
    .joins("INNER JOIN items ON merchants.id = items.merchant_id")
    .joins("INNER JOIN invoice_items ON items.id = invoice_items.item_id")
    .joins("INNER JOIN invoices ON invoices.id = invoice_items.invoice_id")
    .joins("INNER JOIN transactions ON transactions.invoice_id = invoices.id and transactions.result = 'success'")
    .group("merchants.id")
    .order("count desc")
    .limit(num)
  end

  def self.top_revenue(num)
    all
    .select("SUM (invoice_items.quantity * invoice_items.unit_price) as revenue, merchants.*")
    .joins("INNER JOIN items ON merchants.id = items.merchant_id")
    .joins("INNER JOIN invoice_items ON items.id = invoice_items.item_id")
    .joins("INNER JOIN invoices ON invoices.id = invoice_items.invoice_id")
    .joins("INNER JOIN transactions ON transactions.invoice_id = invoices.id and transactions.result = 'success'")
    .group("merchants.id")
    .order("revenue desc")
    .limit(num)
  end

  def total_revenue
    items.joins(invoice_items: :item).joins(merchant: :invoices)
    .joins("INNER JOIN transactions ON transactions.invoice_id = invoices.id")
    .where("transactions.result = 'success'")
    .select("sum(invoice_items.quantity * invoice_items.unit_price) as revenue, merchants.id")
    .group("merchants.id")
  end

  # def self.revenue(first_date, last_date)
  #   all
  #   .select("SUM (invoice_items.quantity * invoice_items.unit_price) as revenue")
  #   .joins("INNER JOIN items ON merchants.id = items.merchant_id")
  #   .joins("INNER JOIN invoice_items ON items.id = invoice_items.item_id")
  #   .joins("INNER JOIN invoices ON invoices.id = invoice_items.invoice_id")
  #   .joins("INNER JOIN transactions ON transactions.invoice_id = invoices.id and transactions.result = 'success'")
  #   .where("transactions.created_at IN (?)", (first_date)..(last_date))
  #
  #
  # end

end
