Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
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
      post 'auth/login', to: 'auth#login'
      post 'auth/register', to: 'auth#register'
      post 'auth/logout', to: 'auth#logout'
      post 'auth/change_password', to: 'auth#change_password'
      get 'auth/profile', to: 'auth#profile'
      put 'auth/update_profile', to: 'auth#update_profile'
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :products, only: [:index, :show]
      resources :orders, only: [:index, :show, :create]
      get 'users/me', to: 'users#show'
      get 'users/orders', to: 'users#orders'
      get 'users/favorites', to: 'users#favorites'
      get 'users/addresses', to: 'users#addresses'
    end
  end
end
