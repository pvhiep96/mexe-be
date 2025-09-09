Rails.application.routes.draw do
  devise_for :admin_users, controllers: {
    sessions: 'admin/sessions'
  }
  namespace :admin do
    root to: "application#index"
    resources :brands
    resources :categories
    resources :products do
      resources :product_images, except: [:show]
      resources :product_descriptions, except: [:show]
    end
    resources :product_images, only: [:index, :destroy]
    resources :orders, only: [:index, :show] do
      member do
        patch :update_shipping
      end
    end
    resources :notifications, only: [:index, :show] do
      member do
        patch :mark_as_read
      end
      collection do
        patch :mark_all_as_read
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # API Routes
  namespace :api do
    namespace :v1 do
      # Auth routes
      post 'auth/login', to: 'auth#login'
      post 'auth/register', to: 'auth#register'
      post 'auth/logout', to: 'auth#logout'
      post 'auth/change_password', to: 'auth#change_password'
      get 'auth/profile', to: 'auth#profile'
      put 'auth/update_profile', to: 'auth#update_profile'
      
      # Home routes
      get 'home', to: 'home#index'
      
      # Resource routes
      resources :products, only: [:index, :show]
      resources :orders, only: [:index, :show, :create]
      
      # Order tracking
      get 'orders/my_orders', to: 'order_tracking#my_orders'
      get 'orders/:id/track', to: 'order_tracking#show'
      post 'orders/track_by_number', to: 'order_tracking#track_by_number'
      resources :categories, only: [:index, :show]
      resources :stores, only: [:index]
      resources :brands, only: [:index, :show]
      
      # User routes
      get 'users/me', to: 'users#show'
      get 'users/orders', to: 'orders#index'
      get 'users/favorites', to: 'users#favorites'
      get 'users/addresses', to: 'users#addresses'
      
      # Debug routes (only in development)
      if Rails.env.development?
        get 'debug/auth_test', to: 'debug#auth_test'
        get 'debug/protected_test', to: 'debug#protected_test'
        get 'debug/test_login', to: 'debug#test_login'
        get 'debug/test_products', to: 'debug#test_products'
        post 'test_orders/create_test_order', to: 'test_orders#create_test_order'
      end
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"


  unless Rails.env.production?
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end
end
