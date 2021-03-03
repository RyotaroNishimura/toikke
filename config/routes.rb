Rails.application.routes.draw do
  root 'static_pages#home'
  post  '/guest_sessions', to: 'guest_sessions#create'
  get '/signup', to:'users#new'
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to:'sessions#destroy'
  get :favorites, to: 'favorites#index'
  resources :posts do
    resource :favorite
  end
  resources :users do
    member do
      get :following, :followers
    end
  end
  resource :posts do
    get :favorites, on: :collection
  end

  resources :relationships, only:[:create, :destroy]
  resources :comments, only: [:create, :destroy]
  resources :notifications, only: :index


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
