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
    render json: items

  end

  def show
    render json: Item.find(params[:id])
  end

  def create
    render json: Item.create(item_params), status: :created
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      render json: @item, status: :accepted
    else
      render json: {data:{}}, status: 400
    end
  rescue StandardError
    render json: {data:{}}, status: 404
  end

  def destroy
    render json: Item.delete(params[:id]), status: :no_content
  end

private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id )
  end

end
