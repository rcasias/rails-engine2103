class Api::V1::ItemsMerchantController < ApplicationController

  def show
    @merchant = Merchant.items_merchant(params[:item_id])[0]
    if !(params[:item_id]).nil? && !@merchant.nil?
      render json: @merchant, status: 200
    else
      render json: {data:{}}, status: 404
    end
  rescue 
    render json: {data:{}}, status: 404
  end

end
