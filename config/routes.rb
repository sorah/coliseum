require 'sidekiq/web'

Coliseum::Application.routes.draw do
  root to: 'top#index'

  resources :submissions, except: %i(destroy update edit) do
    collection do
      get :stream, to: 'live_submissions#stream'
      get :detailed_stream, to: 'live_submissions#detailed_stream'
    end
  end

  resources :problems do
    member do
      get :submissions
    end
  end

  resources :users, except: %i(create new index) do
    member do
      put 'promote' => :promote
      put 'demote' => :demote
    end

    collection do
      get 'me' => :me
    end
  end

  get :leaderboard, to: 'users#leaderboard', as: :leaderboard

  resource :sessions, only: %i(new destroy) do
    get 'signout' => :signout
  end

  scope :auth, controller: 'sessions' do
    get 'failure' => :auth_failure, as: :auth_failure
    get ':provider/callback' => :auth_callback, as: :auth_callback
    post ':provider/callback' => :auth_callback
  end

  mount({Sidekiq::Web => '/sidekiq', constraints: Class.new {
    def matches?(request)
      return false unless request.session[:user_id]
      User.find(request.session[:user_id]).staff?
    rescue ActiveRecord::RecordNotFound
      return false
    end
  }.new})

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
