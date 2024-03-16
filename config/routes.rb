Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :edit, :update, :index]
  root to: "games#index"
  resources :games do
    resources :results
  end
  resources :follows
end
