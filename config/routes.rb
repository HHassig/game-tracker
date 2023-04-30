Rails.application.routes.draw do
  post 'users/:id/follow', to: "users#follow", as: "follow"
  post 'users/:id/unfollow', to: "users#unfollow", as: "unfollow"
  post 'users/:id/accept', to: "users#accept", as: "accept"
  post 'users/:id/decline', to: "users#decline", as: "decline"
  post 'users/:id/cancel', to: "users#cancel", as: "cancel"
  get 'users/:id', to: 'users#show', as: 'users'
  devise_for :users
  root to: "games#index"
  resources :games do
    resources :results
  end
  resources :users, only: [:show, :edit, :update, :index]
end
