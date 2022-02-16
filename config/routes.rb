Rails.application.routes.draw do
  resources :rooms
  resources :users

  resource :confirmation, only: [:show]
  resource :user_sessions, only: [:create, :new]

  get '/user_sessions/destroy', to: 'user_sessions#destroy'
  get '/rooms/destroy/:id', to: 'rooms#destroy'

  resource :reviews, only: [:create, :update], module: :rooms

  root "home#index"
end
