# frozen_string_literal: true

Rails.application.routes.draw do
  get '/navbar-test', to: 'navbar_test#show'

  resources :users
  resources :clients
  resources :articles, only: :show

  get :chat_feature, to: 'chats#show'

  namespace :episodes do
    resources :parts
  end

  namespace :admin do
    resources :users
    resources :clients
  end

  mount Tramway::Engine, at: '/'
end
