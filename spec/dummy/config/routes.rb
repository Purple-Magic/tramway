# frozen_string_literal: true

Rails.application.routes.draw do
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
