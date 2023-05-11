Rails.application.routes.draw do
  root to: 'pages#home'

  devise_for :users

  resources :users, only: %i[create show], shallow: true do
    resources :blogs do
      resources :comments, except: %i[show]
    end
  end

  resources :categories

  get '/about', to: 'pages#about', as: 'about_page'
  match '*path', via: :all, to: redirect('/404')
end
