class ItemSerializer < ActiveModel::Serializer
  type :item
  attributes :name, :description, :unit_price, :merchant_id
end
