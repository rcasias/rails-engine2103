class Api::V1::MerchantsController < ApplicationController

  def index
    page = params[:page] || 1
    per_page = 20
    # Merchant.limit(per_page).offset(page * per_page)
    render json: Merchant.limit(per_page).offset((page.to_i - 1) * per_page)
  end

  def show
    # @merchant = Merchant.find(params[:id])
    # @merchant_items = @merchant.items
    # Merchant.include(:items).find(params[:id])
    # render json: Merchant.includes(:items).find(params[:id])
    render json: Merchant.find(params[:id])
    # binding.pry
  end

end
