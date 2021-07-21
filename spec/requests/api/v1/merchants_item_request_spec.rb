require 'rails_helper'

describe "MerchantsItems" do
  it "finds a items that belong to a merchant" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    create_list(:item, 3, merchant: merchant_1)
    create_list(:item, 3, merchant: merchant_2)
    item = create(:item, merchant: merchant_1, name: "Blue Cup")
    item_2 = create(:item, merchant: merchant_2, name: "Red Cup")
    item_3 = create(:item, merchant: merchant_1, name: "Green Cup")
    get "/api/v1/merchants/#{merchant_1.id}/items"

    merchant_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant_data[:data].count).to eq(5)
  end

  it "cannot find a items that belongs to an merchant that does not exist" do
    merchant_1 = create(:merchant, id: 1)
    merchant_2 = create(:merchant, id: 2)
    create_list(:item, 3, merchant: merchant_2)
    create_list(:item, 3, merchant: merchant_2)
    item = create(:item, merchant: merchant_2, name: "Blue Cup")
    item_2 = create(:item, merchant: merchant_2, name: "Red Cup")
    item_3 = create(:item, merchant: merchant_2, name: "Green Cup")
    get "/api/v1/merchants/1/items"

    merchant_data = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_data[:data]).to eq([])
  end
end
