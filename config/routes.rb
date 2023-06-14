Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  root to: 'pages#home'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :users, only: %i[create show], shallow: true do
    resources :blogs do
      resources :comments, except: %i[show]
    end
  end

  resources :categories
  resources :likes, only: %i[create destroy]

  get '/about', to: 'pages#about', as: 'about_page'
  get '/contact', to: 'pages#contact', as: 'contact_page'
  get '/faqs', to: 'pages#faqs', as: 'faqs_page'

  post '/subscribe', to: 'users#subscribe', as: 'subscribe'

  post '/feedback', to: 'comments#guest_user_feedback', as: 'guest_user_feedback'

  match '*path', via: :all, to: redirect('/404'), constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }
end
