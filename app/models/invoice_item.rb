class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  # def self.most_items_sold(num)
  #   joins(item: :merchant)
  #   .select('sum (invoice_items.quantity) as count', 'items.merchant_id as id', 'merchants.name')
  #   .group('items.merchant_id', 'merchants.name').order('count desc').limit(num)
  # end

  # def self.most_items_sold(num)
  #   ()
  # end
end


# InvoiceItem.joins(:item).select('sum (invoice_items.quantity)', 'items.merchant_id').group('items.merchant_id').order('sum desc')


# SELECT  sum (invoice_items.quantity) as count, merchants.*
# FROM "merchants"
# INNER JOIN
# "items"
# ON "merchants"."id" = "items"."merchant_id"
# INNER JOIN "invoice_items"
# ON "items"."id" = "invoice_items"."item_id"
# Inner JOIN
# "invoices"
# on "invoices"."id" = "invoice_items"."invoice_id"
# INNER JOIN
# "transactions"
# ON "transactions"."invoice_id" = "invoices"."id" and "transactions"."result" = 'success'
# GROUP BY merchants.id
# ORDER BY count desc;
