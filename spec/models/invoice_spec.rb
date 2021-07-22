require 'rails_helper'

RSpec.describe Invoice do
  describe "relationships" do
    it {should have_many :transactions}
    it {should belong_to :customer}
    it {should belong_to :merchant}
  end
end
