Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "index", to: "sign_in#index"

  # Defines the root path route ("/")
  root "sign_in#index"
end
