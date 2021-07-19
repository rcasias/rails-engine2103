class Api::V1::ItemsController < ApplicationController

  def index
    page = params[:page] || 1
    per_page = 20
    render json: Item.limit(per_page).offset((page.to_1 - 1) * per_page)
  end

  def show
    render json: Item.find(params[:id])
  end

  def create
    render json: Item.create(item_params)
  end

  def update
    render json: Item.update(params[:id], item_params)
  end

  def destroy
    render json: Item.delete(params[:id])
  end

private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id )
  end

end
