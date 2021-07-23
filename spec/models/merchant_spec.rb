require 'rails_helper'

RSpec.describe Merchant do
  describe "relationships" do
    it {should have_many :items}
    it {should have_many :invoices}
    it {should have_many(:invoice_items).through(:items)}
  end

  it 'can find an an items merchant' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)
    item = create(:item, merchant: merchant_1)
    items_2 = create_list(:item, 7, merchant: merchant_2)
    items_3 = create_list(:item, 10, merchant: merchant_3)

    expect(Merchant.items_merchant(item.id)[0]). to eq(merchant_1)
  end

  it 'can find an an items merchant and wont return others' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)
    item = create(:item, merchant: merchant_1)
    items_2 = create_list(:item, 7, merchant: merchant_2)
    items_3 = create_list(:item, 10, merchant: merchant_3)

    expect(Merchant.items_merchant(item.id).include?(merchant_2)). to eq(false)
    expect(Merchant.items_merchant(item.id).include?(merchant_3)). to eq(false)
  end

  it 'will return merchants based on search criteria' do
    merchant_1 = create(:merchant, name: 'The Book Store')
    merchant_2 = create(:merchant, name: 'The Clothing Store')
    merchant_3 = create(:merchant, name: 'The Furniture Store')

    expect(Merchant.search('Furniture')).to eq(merchant_3)
  end

  it 'will return merchants based on search criteria - alphabetical order' do
    merchant_1 = create(:merchant, name: 'The Book Store')
    merchant_2 = create(:merchant, name: 'The Furniture Outlet')
    merchant_3 = create(:merchant, name: 'The Furniture Store')

    expect(Merchant.search('Furniture')).to eq(merchant_2)
  end

  it 'can return most items sold for a merchant' do
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
    # binding.pry
    expect(Merchant.most_items_sold(3).first).to eq(merchant_3)
    expect(Merchant.most_items_sold(3)[1]).to eq(merchant_1)
    expect(Merchant.most_items_sold(3).last).to eq(merchant_2)
  end

  it 'can return most items sold for a merchant only two merchants' do
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

    expect(Merchant.most_items_sold(2).first).to eq(merchant_3)
    expect(Merchant.most_items_sold(2).last).to eq(merchant_1)
    expect(Merchant.most_items_sold(2).include?(merchant_2)).to eq(false)
  end

  it 'can return top revenue for a merchants' do
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

    expect(Merchant.top_revenue(2).first).to eq(merchant_1)
    expect(Merchant.top_revenue(2).last).to eq(merchant_2)
    expect(Merchant.top_revenue(2).include?(merchant_3)).to eq(false)
  end

  xit 'can calculate revenue for merchant' do
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

    invoice_items_1 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_1.id, quantity: 5, unit_price: 1)
    invoice_items_2 = InvoiceItem.create(item_id: item_2.id, invoice_id: invoice_2.id, quantity: 1, unit_price: 1)
    invoice_items_3 = InvoiceItem.create(item_id: item_2.id, invoice_id: invoice_3.id, quantity: 4, unit_price: 1)
    invoice_items_4 = InvoiceItem.create(item_id: item_3.id, invoice_id: invoice_4.id, quantity: 10, unit_price: 1)
    invoice_items_5 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_5.id, quantity: 2, unit_price: 1)
    invoice_items_6 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_6.id, quantity: 2, unit_price: 1)

    transactions_1 = Transaction.create(invoice_id: invoice_1.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'success')
    transactions_2 = Transaction.create(invoice_id: invoice_2.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'success')
    transactions_3 = Transaction.create(invoice_id: invoice_3.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'success')
    transactions_4 = Transaction.create(invoice_id: invoice_4.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'success')
    transactions_5 = Transaction.create(invoice_id: invoice_5.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'fail')

    expect(merchant_1.total_revenue[0].revenue).to eq(7.00)
  end
end
