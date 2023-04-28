Rails.application.routes.draw do
  root to: 'pages#home'

  resources :posts do
    resources :comments, shallow: true, except: %i[show new edit]
  end

  resources :users, only: :create

  resources :categories
end
