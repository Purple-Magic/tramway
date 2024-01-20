# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  resources :clients

  namespace :episodes do
    resources :parts
  end

  namespace :admin do
    resources :users
    resources :clients
  end
end
