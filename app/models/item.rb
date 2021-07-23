class Item < ApplicationRecord
  belongs_to :merchant, dependent: :destroy
  has_many :invoice_items, dependent: :destroy


  def self.search(search_params)
    where("name ILIKE ?", "%#{search_params}%")
  end
end
