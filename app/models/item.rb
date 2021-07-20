class Item < ApplicationRecord
  belongs_to :merchant
  #add a dependent destroy

  def self.search(search_params)
    where("name ILIKE ?", "%#{search_params}%")
  end
end
