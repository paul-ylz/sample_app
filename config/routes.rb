require 'api_constraints'

Rails.application.routes.draw do

  root              to: 'static_pages#home'
  match '/help',    to: 'static_pages#help', via: 'get'
  match '/about',   to: 'static_pages#about', via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  match '/signup',  to: 'users#new', via: 'get'
  match '/signin',  to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/activate/:id', to: 'users#activate', via: 'get'
  match '/feed(.:format)', to: 'static_pages#home', via: 'get'

  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :password_resets
  resources :api_keys, only: [:create]

  resources :users do 
    member do 
      get :following, :followers
    end
  end

  resources :messages, only: [:new, :create, :index, :show, :destroy] do 
    get 'reply', on: :member 
    get 'sent', on: :collection
  end

  namespace :api, defaults: { format: 'json' } do 
   scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do

      resources :users do 
        member do 
          get :following, :followers
        end
      end

      resources :relationships, only: [:create, :destroy]

      resources :microposts, only: [:create, :destroy]

      match '/feed', to: 'users#feed', via: 'get'
    end
  end
end