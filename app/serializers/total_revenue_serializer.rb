class TotalRevenueSerializer < ActiveModel::Serializer
  type :merchant_revenue

  attributes :revenue,:id
end
