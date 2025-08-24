Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication routes
  resources :users, only: [ :new, :create ]
  get "login" => "sessions#new"
  delete "logout" => "sessions#destroy"

  # Main app routes (views)
  resources :vaults do
    resources :entries
    resources :contexts do
      member do
        post :add_entry
        delete :remove_entry
      end
    end
    resources :mailboxes, only: [ :index, :show, :create, :destroy ]
  end

  # API routes
  namespace :api do
    resources :vaults do
      resources :entries
      resources :contexts do
        member do
          post :add_entry
          delete :remove_entry
        end
      end
      resources :mailboxes, only: [ :index, :show, :create, :update, :destroy ]
    end
  end

  # Root path
  root "vaults#index"
end
