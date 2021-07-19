class ItemSerializer
  include JSONAPI::Serializer
  set_key_transform :underscore

  set_type :item
  attributes :name, :description, :unit_price, :merchant_id
end
