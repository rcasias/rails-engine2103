class Api::V1::ItemsController < ApplicationController

  def index
    # page = params[:page] || 1
    # per_page = 20
    # render json: Item.limit(per_page).offset((page.to_1 - 1) * per_page)
    page = params[:page] || 1
    if page.to_i <= 0
      page = 1
    end
    per_page = params[:per_page]
    per_page_to_i = per_page.to_i
    if per_page_to_i == 0 || per_page_to_i == nil
      per_page_to_i = 20
    end
    items =  Item.limit(per_page_to_i).offset((page.to_i - 1) * per_page_to_i)
    json_string = ItemSerializer.new(items).serializable_hash.to_json
    render json: json_string

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
