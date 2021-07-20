class Merchant < ApplicationRecord
  has_many :items


  def self.items_merchant(id)
    joins(:items).select('merchants.*', 'items.merchant_id', 'items.id as item_id')
    .where('items.id = ?', id)
  end

  def self.search(search_params)
    where("name ILIKE ?", "%#{search_params}%").order(:name)
  end

end
