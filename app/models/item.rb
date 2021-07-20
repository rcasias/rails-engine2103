class Item < ApplicationRecord
  belongs_to :merchant
  #add a dependent destroy

  # def self.items_merchant(id)
  #   joins(:merchant).select('merchants.*', 'items.merchant_id', 'items.id as item_id')
  #   .where('items.id = ?', id)
  # end
end
