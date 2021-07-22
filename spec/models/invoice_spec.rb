require 'rails_helper'

RSpec.describe Transaction do
  describe "relationships" do
    it {should belong_to :invoice}
    it {should have_many :customers}
    it {should have_many :merchants}
  end
end
