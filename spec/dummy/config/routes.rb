# frozen_string_literal: true

Rails.application.routes.draw do
  mount Tramway::Engine, at: '/'

  resources :users
  resources :clients
  resources :articles, only: :show

  resource :chat, only: :show

  namespace :episodes do
    resources :parts
  end

  namespace :admin do
    resources :users
    resources :clients
  end
end
