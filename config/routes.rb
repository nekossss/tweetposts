Rails.application.routes.draw do
  root to: 'toppages#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  

  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :new, :create, :destroy, :edit, :update] do
    member do
      get :followings
      get :followers
      get :likes
    end
    collection do
      get :search
    end
  end
  
  resources :tweetposts, only: [:create, :destroy, :edit, :update, :show]
  post 'tweetposts/:id' => 'tweetposts#show'
  
  resources :relationships, only: [:create, :destroy]
  resources :likerelationships, only: [:create, :destroy]
  
  
end