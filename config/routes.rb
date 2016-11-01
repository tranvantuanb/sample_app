Rails.application.routes.draw do
  get "password_resets/new"

  get "password_resets/edit"

  root "static_page#home"
  get "/help", to: "static_page#help"
  get "/about", to: "static_page#about"
  get "/contact", to: "static_page#contact"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, except: [:index, :show, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
