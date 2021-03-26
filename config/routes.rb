# == Route Map
#

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :admin do
    resources :users
  end

  devise_for :users

  authenticate :admin_user do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  root 'videos#index'

  post 'savenew',  to: 'users#savenew'
  get '/watch',    to: 'videos#show'
  get '/privacy',  to: 'static_pages#privacy'
  get '/terms',    to: 'static_pages#terms'
  get '/about',    to: 'static_pages#about'

  mount Searchjoy::Engine, at: "searchjoy"

  resources :channels, only: :index
  resources :playlists, only: :index
  resources :videos, except: :show
  resources :search_suggestions, only: :index
  resources :leaders, only: :index
  resources :followers, only: :index
  resources :events, only: :index
  resources :songs, only: :index
end
