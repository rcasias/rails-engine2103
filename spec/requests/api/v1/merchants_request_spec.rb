require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
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
    # binding.pry
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
end
