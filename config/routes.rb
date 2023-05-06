Rails.application.routes.draw do
  root to: 'pages#home'

  devise_for :users 

  resources :users, only: [:create], shallow: true do
    resources :posts do
      resources :comments, except: %i[show new]
    end
  end

  resources :categories
  match '*path', via: :all, to: redirect('/404')
end
