Rails.application.routes.draw do
  root to: 'posts#index'

  resources :posts do 
    resources :comments, shallow: true
  end
  resources :users
end
