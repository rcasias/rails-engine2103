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
    merchant = Merchant.search(params[:name])
    if !merchant.nil?
      render json: merchant, status: :ok
    else
      render json: {data:{}}, status: 404
    end
  end

  def quantity
    n = params[:quantity]

    if n.nil?
      render json: {
                    "message": "your query could not be completed",
                    "error": [
                      "please enter a quantity"
                    ]
                    }, status: 400 and return
    end                
    @records =  Merchant.top_revenue(n)
    render :json => @records, each_serializer: RevenueSerializer, status: 200
  end

  def most_items
    n = params[:quantity]

    if n.nil?
      render json: {
                    "message": "your query could not be completed",
                    "error": [
                      "please enter a quantity"
                    ]
                    }, status: 400 and return
    elsif n.to_i <= 0
      render json: {data:{}}, status: 400 and return
    elsif n.to_i >= 100
      n = Merchant.all.length
    end

    if Merchant.all.length > 0
      @records =  Merchant.most_items_sold(n)
      render :json => @records, each_serializer: MostItemSerializer, status: 200
    else
      render json: {data:{}}, status: 400
    end
  end

end
