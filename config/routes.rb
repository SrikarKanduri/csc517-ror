Rails.application.routes.draw do

  # Others
  resources :users
  resources :tours
  resources :reviews

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

  # # RailsAdmin link
  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Home page
  root 'home#index'

  get '/', to: "home#index", as: "home"

  # # Show Profile page
  # get "/users/:id", to: "users#show", as: "user"
  #
  # # Edit Profile
  # get "/users/:id/edit", to:"users#edit", as: "edit_user"
  #
  # # Update Profile
  # patch "users/:id", to: "users#update"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
