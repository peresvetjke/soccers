Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root to: "matches#index"

  resources :matches, only: :index

  resources :teams, only: :index
end
