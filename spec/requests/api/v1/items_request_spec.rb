require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:merchant, 1, id: 1)
    create_list(:item, 3, merchant_id: 1)

    get '/api/v1/items'

    expect(response).to be_successful
  end

  it "sends a list of items" do
    create_list(:merchant, 1, id: 1)
    create_list(:item, 3, merchant_id: 1)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(Integer)

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to eq(1)
    end
  end

  it "can get one item by its id" do
    create_list(:merchant, 1, id: 1)
    id = create(:item, merchant_id: 1).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an(Integer)

    expect(item).to have_key(:name)
    expect(item[:name]).to be_a(String)

    expect(item).to have_key(:description)
    expect(item[:description]).to be_a(String)

    expect(item).to have_key(:unit_price)
    expect(item[:unit_price]).to be_a(Float)

    expect(item).to have_key(:merchant_id)
    expect(item[:merchant_id]).to eq(1)
  end

  it "can create a new item" do
    create_list(:merchant, 1, id: 1)
    item_params = ({
                    name: 'Big soft blanket',
                    description: 'Burnt orange in color. Fits twin/ queen bed.',
                    unit_price: 59.99,
                    merchant_id: 1,
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end
end
