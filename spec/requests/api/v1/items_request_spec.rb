require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:merchant, 1, id: 1)
    create_list(:item, 3, merchant_id: 1)

    get '/api/v1/items'

    expect(response).to be_successful
  end

  it 'will default to page 1' do
    create_list(:merchant, 1, id: 1)
    list = create_list(:item, 21, merchant_id: 1)

    get "/api/v1/items?page=0"

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(item_data[:data].count).to eq(20)
    expect(item_data[:data].include?(list[-1])).to eq(false)
  end

  it 'has 20 items per page' do
    create_list(:merchant, 1, id: 1)
    list = create_list(:item, 21, merchant_id: 1)

    get "/api/v1/items"

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(item_data[:data].count).to eq(20)
    expect(item_data[:data].include?(list[-1])).to eq(false)
  end

  it 'has 20 items per page page 2' do
    create_list(:merchant, 1, id: 1)
    list = create_list(:item, 21, merchant_id: 1)

    get "/api/v1/items?page=2"

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(item_data[:data].count).to eq(1)
    expect(item_data[:data].include?(list[0..19])).to eq(false)
  end

  it "sends a list of items" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    create_list(:item, 3, merchant: merchant_1)
    create_list(:item, 3, merchant: merchant_2)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(6)

    items[:data].each do |item|
      # binding.pry
      expect(item).to have_key(:id)
      expect(item[:id].to_i).to be_an(Integer)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price].to_f).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
    end
  end

  it "can get one item by its id" do
    create_list(:merchant, 1, id: 1)
    id = create(:item, merchant_id: 1).id

    get "/api/v1/items/#{id}"

    item_data = JSON.parse(response.body, symbolize_names: true)
    item = item_data[:data]
    expect(response).to be_successful
    # binding.pry
    expect(item).to have_key(:id)
    expect(item[:id].to_i).to be_an(Integer)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price].to_f).to be_a(Float)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to eq(1)
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

  it "can update an existing item" do
    create_list(:merchant, 1, id: 1)
    id = create(:item, merchant_id: 1).id

    previous_item_description = Item.last.description
    item_params = { description: "100% acrylic blanket" }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.description).to_not eq(previous_item_description)
    expect(item.description).to eq("100% acrylic blanket")
  end

  it "can fail to update an existing item" do
    create_list(:merchant, 1, id: 1)
    id = create(:item, merchant_id: 1).id

    previous_item_description = Item.last.description
    item_params = {  }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to_not be_successful
  end

  it "can destroy an item" do
    create_list(:merchant, 1, id: 1)
    id = create(:item, merchant_id: 1).id
    item = Item.find_by(id: id)

    expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)
    expect(response).to be_success
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can search for multiple items' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    create_list(:item, 3, merchant: merchant_1)
    create_list(:item, 3, merchant: merchant_2)
    item = create(:item, merchant: merchant_1, name: "Blue Cup")
    item_2 = create(:item, merchant: merchant_1, name: "Red Cup")
    item_3 = create(:item, merchant: merchant_1, name: "Green Cup")
    get "/api/v1/items/find_all?name=cup"
    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(Item.all.count).to eq(9)
    expect(item_data[:data].count).to eq(3)
    expect(item_data[:data].first[:attributes][:name]).to eq(item.name)
    expect(item_data[:data].last[:attributes][:name]).to eq(item_3.name)
  end

  it 'can search for multiple items and fail to find results' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    create_list(:item, 3, merchant: merchant_1)
    create_list(:item, 3, merchant: merchant_2)
    item = create(:item, merchant: merchant_1, name: "Blue Cup")
    item_2 = create(:item, merchant: merchant_1, name: "Red Cup")
    item_3 = create(:item, merchant: merchant_1, name: "Green Cup")
    get "/api/v1/items/find_all?name=elephant"
    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(Item.all.count).to eq(9)
    expect(item_data[:data].count).to eq(0)
    expect(item_data[:data]).to eq([])
  end

end
