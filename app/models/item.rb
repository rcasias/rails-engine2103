class Item < ApplicationRecord
  belongs_to :merchant
  #add a dependent destroy

  def items_merchant(id)
    joins(:merchant).select('merchants.*', 'items.merchant_id')
    .where('merchants.id' == id)
  end
end
