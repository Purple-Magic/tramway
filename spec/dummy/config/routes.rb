# frozen_string_literal: true

Rails.application.routes.draw do
  mount Tramway::Engine => '/tramway'

  resources :users

  namespace :episodes do
    resources :parts
  end
end
