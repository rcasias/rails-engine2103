class Api::V1::ItemsMerchantController < ApplicationController

  def index
    render json: Item.items_merchant(params[:id])
  end

end
