class RevenueSerializer < ActiveModel::Serializer
  type :merchant_name_revenue

  attributes :revenue, :name, :id
end
