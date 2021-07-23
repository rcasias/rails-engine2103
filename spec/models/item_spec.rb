require 'rails_helper'

RSpec.describe Item do
  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
  end

  it 'will return merchants based on search criteria' do
    merchant_1 = create(:merchant)
    item_1 = create(:item, name: 'Red Blanket', merchant: merchant_1)
    item_2 = create(:item, name: 'Orange Blanket', merchant: merchant_1)
    item_3 = create(:item, name: 'Green Blanket', merchant: merchant_1)
    item_4 = create(:item, name: 'Plastic Reusable Cup', merchant: merchant_1)
    item_5 = create(:item, name: 'Brush', merchant: merchant_1)
    item_6 = create(:item, name: 'Picture Frame', merchant: merchant_1)

    expect(Item.search('Blanket').to_a).to eq([item_1, item_2, item_3])
  end

  it 'can return top revenue for a items' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    customer_1 = Customer.create(first_name: "Riley", last_name: "Casias")
    customer_2 = Customer.create(first_name: "Daxton", last_name: "Casias")
    customer_3 = Customer.create(first_name: "Michael", last_name: "Ochoa")

    item = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_2)
    item_3 = create(:item, merchant: merchant_3)

    invoice_1 = Invoice.create(customer: customer_1, merchant: merchant_1, status: 'shipped')
    invoice_2 = Invoice.create(customer: customer_2, merchant: merchant_2, status: 'shipped')
    invoice_3 = Invoice.create(customer: customer_3, merchant: merchant_2, status: 'shipped')
    invoice_4 = Invoice.create(customer: customer_2, merchant: merchant_3, status: 'shipped')
    invoice_5 = Invoice.create(customer: customer_2, merchant: merchant_1, status: 'shipped')
    invoice_6 = Invoice.create(customer: customer_3, merchant: merchant_1, status: 'shipped')

    invoice_items_1 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_1.id, quantity: 5)
    invoice_items_2 = InvoiceItem.create(item_id: item_2.id, invoice_id: invoice_2.id, quantity: 1)
    invoice_items_3 = InvoiceItem.create(item_id: item_2.id, invoice_id: invoice_3.id, quantity: 4)
    invoice_items_4 = InvoiceItem.create(item_id: item_3.id, invoice_id: invoice_4.id, quantity: 10)
    invoice_items_5 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_5.id, quantity: 2)
    invoice_items_6 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_6.id, quantity: 2)

    transactions_1 = Transaction.create(invoice_id: invoice_1.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'success')
    transactions_2 = Transaction.create(invoice_id: invoice_2.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'success')
    transactions_3 = Transaction.create(invoice_id: invoice_3.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'success')
    transactions_4 = Transaction.create(invoice_id: invoice_4.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'success')
    transactions_5 = Transaction.create(invoice_id: invoice_5.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'fail')

    expect(Item.top_item_revenue(2).first).to eq(item)
    expect(Item.top_item_revenue(2).last).to eq(item_2)
    expect(Item.top_item_revenue(2).include?(item_3)).to eq(false)
  end

end
