Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :edit, :update, :index]
  root to: "games#index"
  resources :games do
    resources :results
  end
  post 'users/:id/follow', to: "users#follow", as: "follow"
  post 'users/:id/unfollow', to: "users#unfollow", as: "unfollow"
  post 'users/:id/accept', to: "users#accept", as: "accept"
  post 'games/:id/follow', to: "games#follow", as: "game-follow"
  post 'games/:id/unfollow', to: "games#unfollow", as: "game-unfollow"
  post 'games/:id/accept', to: "games#accept", as: "game-accept"
  # post 'users/:id/decline', to: "users#decline", as: "decline"
  # post 'users/:id/cancel', to: "users#cancel", as: "cancel"
end
