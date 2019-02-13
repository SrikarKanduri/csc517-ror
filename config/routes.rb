Rails.application.routes.draw do
  root 'landing_page#index'

  get 'landing_page/index'
  get 'landing_page/welcome'
  get 'hello_page/hello'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
