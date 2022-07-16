Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "sign_in", to: "sign_in#index"
  get '/auth/spotify/callback', to: 'callbacks#spotify'

  resources :playlists, only: %i[index show] do
    resources :votes, only: %i[create new] do
      get :random, on: :collection
      get :search, on: :collection
    end
  end

  # Defines the root path route ("/")
  root "sign_in#index"
end
