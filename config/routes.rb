Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get '/merchants/most_items', to: 'merchants#most_items'
      get '/merchants/find', to: 'merchants#find'
      resources :merchants, only: [:index, :show] do
        resources :items, controller: :merchant_items, only: :index
      end
    end
  end

  namespace :api do
    namespace :v1 do
      get '/items/find_all', to: 'items#find_all'
      resources :items do
        resource :merchant, controller: :items_merchant, only: :show
      end
    end
  end

  get '/api/v1/revenue/merchants', to: 'api/v1/merchants#quantity'
  get '/api/v1/revenue/merchants/:id', to: 'api/v1/merchants#revenue'

  get '/api/v1/revenue/items', to: 'api/v1/items#total_revenue'

end
