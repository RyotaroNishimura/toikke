Rails.application.routes.draw do
  root 'static_pages#home'
  get '/signup', to:'users#new'
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to:'sessions#destroy'
  get :favorites, to: 'favorites#index'
  post "favorites/:post_id/create" => "favorites#create"
  delete "favorites/:post_id/destroy" => "favorites#destroy"
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :posts
  resources :relationships, only:[:create, :destroy]
  resources :comments, only: [:create, :destroy]
  resources :notifications, only: :index


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
