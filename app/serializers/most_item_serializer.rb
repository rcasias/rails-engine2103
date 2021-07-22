class MostItemSerializer < ActiveModel::Serializer
  type :items_sold

  attributes :count, :name, :id
end
