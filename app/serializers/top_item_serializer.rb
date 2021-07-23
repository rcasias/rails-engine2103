class TopItemSerializer < ActiveModel::Serializer
  type :item_revenue

  attributes :revenue,:id, :name, :description, :unit_price, :merchant_id
end
# {
#   "data": [
#     {
#       "id": 4,
#       "type": "item_revenue",
#       "attributes": {
#         "name": "Men's Titanium Ring",
#         "description": "Fine titanium ring",
#         "unit_price": 299.99,
#         "merchant_id": 54,
#         "revenue": 19823.12985
#       }
#     }
#   ]
# }
