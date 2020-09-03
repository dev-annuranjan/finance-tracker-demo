Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :destroy]
  resources :friendships, only: [:create, :destroy]
  devise_for :users
  resources :users, only: [:show]
  root 'welcome#index'
  get 'my_portfolio' => 'users#my_portfolio'
  get 'search_stock' => 'stocks#search'
  get 'my_friends' => 'users#my_friends'
  get 'search_friend' => 'users#search_friend'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
