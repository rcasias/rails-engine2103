require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
  end

  it 'will default to page 1' do
    list = create_list(:merchant, 21)

    get "/api/v1/merchants?page=0"

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(item_data[:data].count).to eq(20)
    expect(item_data[:data].include?(list[-1])).to eq(false)
  end

  it 'has 20 merchants per page' do
    list = create_list(:merchant, 21)

    get "/api/v1/merchants"

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(item_data[:data].count).to eq(20)
    expect(item_data[:data].include?(list[-1])).to eq(false)
  end

  it 'has 20 merchants per page page 2' do
    list = create_list(:merchant, 21)

    get "/api/v1/merchants?page=2"

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(item_data[:data].count).to eq(1)
    expect(item_data[:data].include?(list[0..19])).to eq(false)
  end

  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant_data = JSON.parse(response.body, symbolize_names: true)
    merchant = merchant_data[:data]
    expect(response).to be_successful

    expect(merchant).to have_key(:id)
    expect(merchant[:id].to_i).to eq(id)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it 'can find all items for a merchant' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)
    items = create_list(:item, 3, merchant: merchant_1)
    items_2 = create_list(:item, 7, merchant: merchant_2)
    items_3 = create_list(:item, 10, merchant: merchant_3)

    get "/api/v1/merchants/#{merchant_1.id}/items"
    items_data = JSON.parse(response.body, symbolize_names: true)
    items = items_data[:data]

    expect(items.length).to eq(3)
    expect(response).to be_successful
    expect(items.first).to have_key(:id)
    expect(items.first).to have_key(:type)
    expect(items.first).to have_key(:attributes)
    expect(items.first[:attributes]).to have_key(:name)
    expect(items.first[:attributes]).to have_key(:description)
    expect(items.first[:attributes]).to have_key(:unit_price)
    expect(items.first[:attributes]).to have_key(:merchant_id)
  end

  it 'can find a single merchant based on a seach' do
    merchant_1 = create(:merchant, name: 'La-Z-Boy Home Furniture Galleries')
    merchant_2 = create(:merchant, name: 'La-Z-Boy Home Furnishings and Decor')
    merchant_3 = create(:merchant, name: 'Albertsons')
    merchant_4 = create(:merchant, name: 'Target')

    get "/api/v1/merchants/find?name=La-Z-Boy"

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(Merchant.all.count).to eq(4)
    expect(item_data.count).to eq(1)
    expect(item_data[:data][:attributes][:name]).to eq(merchant_2.name)
  end

  it 'can fail to find a single merchant based on a seach' do
    merchant_1 = create(:merchant, name: 'La-Z-Boy Home Furniture Galleries')
    merchant_2 = create(:merchant, name: 'La-Z-Boy Home Furnishings and Decor')
    merchant_3 = create(:merchant, name: 'Albertsons')
    merchant_4 = create(:merchant, name: 'Target')

    get "/api/v1/merchants/find?name=icecream"

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(Merchant.all.count).to eq(4)
    expect(item_data[:data].count).to eq(0)
    expect(item_data[:data]).to eq({})
  end

  describe "Active Record Queries" do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)

      @customer_1 = Customer.create(first_name: "Riley", last_name: "Casias")
      @customer_2 = Customer.create(first_name: "Daxton", last_name: "Casias")
      @customer_3 = Customer.create(first_name: "Michael", last_name: "Ochoa")

      @item = create(:item, merchant: @merchant_1)
      @item_2 = create(:item, merchant: @merchant_2)
      @item_3 = create(:item, merchant: @merchant_3)

      @invoice_1 = Invoice.create(customer: @customer_1, merchant: @merchant_1, status: 'shipped')
      @invoice_2 = Invoice.create(customer: @customer_2, merchant: @merchant_2, status: 'shipped')
      @invoice_3 = Invoice.create(customer: @customer_3, merchant: @merchant_2, status: 'shipped')
      @invoice_4 = Invoice.create(customer: @customer_2, merchant: @merchant_3, status: 'shipped')
      @invoice_5 = Invoice.create(customer: @customer_2, merchant: @merchant_1, status: 'shipped')
      @invoice_6 = Invoice.create(customer: @customer_3, merchant: @merchant_1, status: 'shipped')

      @invoice_items_1 = InvoiceItem.create(item_id: @item.id, invoice_id: @invoice_1.id, quantity: 5)
      @invoice_items_2 = InvoiceItem.create(item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 1)
      @invoice_items_3 = InvoiceItem.create(item_id: @item_2.id, invoice_id: @invoice_3.id, quantity: 4)
      @invoice_items_4 = InvoiceItem.create(item_id: @item_3.id, invoice_id: @invoice_4.id, quantity: 10)
      @invoice_items_5 = InvoiceItem.create(item_id: @item.id, invoice_id: @invoice_5.id, quantity: 2)
      @invoice_items_6 = InvoiceItem.create(item_id: @item.id, invoice_id: @invoice_6.id, quantity: 2)

      @transactions_1 = Transaction.create(invoice_id: @invoice_1.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'success')
      @transactions_2 = Transaction.create(invoice_id: @invoice_2.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'success')
      @transactions_3 = Transaction.create(invoice_id: @invoice_3.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'success')
      @transactions_4 = Transaction.create(invoice_id: @invoice_4.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'success')
      @transactions_5 = Transaction.create(invoice_id: @invoice_5.id, credit_card_number: '123456', credit_card_expiration_date: '1220', result: 'fail')
    end

    it 'can return most items sold for a merchant' do
      get "/api/v1/merchants/most_items?quantity=3"

      merchant_data = JSON.parse(response.body, symbolize_names: true)
      # binding.pry
      expect(merchant_data[:data].first[:id]).to eq(@merchant_3.id.to_s)
      expect(merchant_data[:data][1][:id]).to eq(@merchant_1.id.to_s)
      expect(merchant_data[:data].last[:id]).to eq(@merchant_2.id.to_s)
    end

    it 'can return most items sold for a merchant no quantity given error' do
      get "/api/v1/merchants/most_items"

      merchant_data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
    end

    it 'can return most items sold for a merchant no quantity is 0 error' do
      get "/api/v1/merchants/most_items?quantity=0"

      merchant_data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
    end

    it 'can return most items sold for a merchant- quantity is 100 ' do
      get "/api/v1/merchants/most_items?quantity= 150"

      merchant_data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant_data[:data].first[:id]).to eq(@merchant_3.id.to_s)
      expect(merchant_data[:data][1][:id]).to eq(@merchant_1.id.to_s)
      expect(merchant_data[:data].last[:id]).to eq(@merchant_2.id.to_s)
    end

    it 'can return top revenue for a merchants - non sucessful for not having a quantity' do
      get "/api/v1/revenue/merchants"

      merchant_data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
    end

    it 'can return top revenue for a merchants' do
      get "/api/v1/revenue/merchants?quantity= 150"

      merchant_data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant_data[:data].first[:id]).to eq(@merchant_1.id.to_s)
      expect(merchant_data[:data][1][:id]).to eq(@merchant_2.id.to_s)
      expect(merchant_data[:data].last[:id]).to eq(@merchant_3.id.to_s)
    end

  end

end
