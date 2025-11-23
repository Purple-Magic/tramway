# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  resources :clients
  resources :articles, only: :show do
    get :feed, on: :collection
  end

  namespace :episodes do
    resources :parts
  end

  mount Tramway::Engine, at: '/admin'

  namespace :admin do
    resources :users
    resources :clients
  end
end
