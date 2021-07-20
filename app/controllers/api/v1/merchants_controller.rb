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
    render json: merchant
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: merchant
  end

  def find
    binding.pry
  end

end
