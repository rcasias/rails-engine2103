class MerchantSerializer
  include JSONAPI::Serializer
  set_key_transform :underscore

  set_type :merchant
  # set_id :id
  attributes :name
  # has_many :items
end
