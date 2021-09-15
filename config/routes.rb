Rails.application.routes.draw do
  devise_for :users

  resources :users,only: [:show,:index,:edit,:update] do
    member do
      get :follows
      get :follower
      resource :relationships, only: [:create, :destroy]
    end
  end
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :chats, only: [:show, :create]
  resources :groups do
    resource :group_users, only: [:create, :destroy]
  end

  root 'homes#top'
  get 'home/about' => 'homes#about'
  get 'searches/search'
end