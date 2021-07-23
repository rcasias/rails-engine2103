class TopItemSerializer < ActiveModel::Serializer
  type :item_revenue

  attributes :revenue,:id, :name, :description, :unit_price, :merchant_id
end
