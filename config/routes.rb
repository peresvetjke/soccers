Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root to: "matches#index"

  resources :matches, only: :index

  resources :teams, only: :index do
    post    :add_to_favorites,      to: :add_to_favorites,      on: :member
    delete  :remove_from_favorites, to: :remove_from_favorites, on: :member
  end
end
