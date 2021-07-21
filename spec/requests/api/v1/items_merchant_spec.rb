require 'rails_helper'

describe "ItemsMerchant" do
  it "finds a merchant that belongs to an item" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    create_list(:item, 3, merchant: merchant_1)
    create_list(:item, 3, merchant: merchant_2)
    item = create(:item, merchant: merchant_1, name: "Blue Cup")
    item_2 = create(:item, merchant: merchant_2, name: "Red Cup")
    item_3 = create(:item, merchant: merchant_1, name: "Green Cup")
    get "/api/v1/items/#{item.id}/merchant"

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item_data[:data][:attributes][:name]).to eq(merchant_1.name)
  end

  it "cannot find a merchant that belongs to an item that does not exist" do
    merchant_1 = create(:merchant, id: 1)
    merchant_2 = create(:merchant, id: 2)
    create_list(:item, 3, merchant: merchant_1)
    create_list(:item, 3, merchant: merchant_2)
    item = create(:item, merchant: merchant_1, name: "Blue Cup")
    item_2 = create(:item, merchant: merchant_2, name: "Red Cup")
    item_3 = create(:item, merchant: merchant_1, name: "Green Cup")
    get "/api/v1/items/7/merchant"

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(item_data[:data]).to eq({})
  end
end
