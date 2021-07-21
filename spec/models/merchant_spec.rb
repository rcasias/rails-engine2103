require 'rails_helper'

RSpec.describe Merchant do
  describe "relationships" do
    # it {should have_many :items}
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
end
