Rails.application.routes.draw do
  get 'comments/edit'
  get 'comments/index'
  get 'pages/home'
  get 'posts/edit'
  get 'posts/index'
  get 'posts/new'
  get 'posts/show'
  root to: 'pages#home'

  resources :posts do
    resources :comments, shallow: true, except: %i[show new edit]
  end

  resources :users, only: :create
end
