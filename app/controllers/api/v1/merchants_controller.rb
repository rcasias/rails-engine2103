class Api::V1::MerchantsController < ApplicationController

  def index
    page = params[:page] || 1
    if page.to_i <= 0
      page = 1
    end
    per_page = params[:per_page]
    per_page_to_i = per_page.to_i
    if per_page_to_i == 0 || per_page_to_i == nil
      per_page_to_i = 20
    end
    merchant =  Merchant.limit(per_page_to_i).offset((page.to_i - 1) * per_page_to_i)
    json_string = MerchantSerializer.new(merchant).serializable_hash.to_json
    render json: json_string
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
