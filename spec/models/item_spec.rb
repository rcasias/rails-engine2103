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

end
