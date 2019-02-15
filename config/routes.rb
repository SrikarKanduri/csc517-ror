Rails.application.routes.draw do

  # Generated from Clearance
  resources :passwords, controller: "passwords", only: [:create, :new]
  resource :session, controller: "sessions", only: [:create]

  # Generated from Clearance
  resources :users, controller: "users", only: [:create] do
    resource :password,
      controller: "passwords",
      only: [:create, :edit, :update]
  end

  # Generated from Clearance
  get "/sign_in" => "sessions#new", as: "sign_in"
  delete "/sign_out" => "sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"

  # Home page
  root 'landing_page#index'

  get 'landing_page/index'
  get 'landing_page/welcome'
  get 'hello_page/hello'

  # RailsAdmin link
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :customers
  resources :agents
  resources :tours

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
