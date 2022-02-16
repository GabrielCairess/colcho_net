Rails.application.routes.draw do
  resources :users
  
  resources :rooms do
    resources :reviews, only: [:create, :update], module: :rooms
  end

  resource :confirmation, only: [:show]
  resource :user_sessions, only: [:create, :new]

  get '/user_sessions/destroy', to: 'user_sessions#destroy'
  get '/rooms/destroy/:id', to: 'rooms#destroy'

  root "home#index"
end
