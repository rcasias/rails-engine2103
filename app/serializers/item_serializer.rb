class ItemSerializer
  include JSONAPI::Serializer
  set_key_transform :underscore

  # set_type :merchant  # optional
  # set_id :id # optional
  attributes :id, :name
  belongs_to :merchant
end
