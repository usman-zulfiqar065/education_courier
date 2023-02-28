Rails.application.routes.draw do
  resources :comments
  root to: 'posts#index'
  resources :posts
  resources :users
end
