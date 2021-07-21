class Api::V1::MerchantItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_items = @merchant.items
    render json: @merchant_items, status: :ok
  end
end
