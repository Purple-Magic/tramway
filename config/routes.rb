# frozen_string_literal: true

Tramway::Engine.routes.draw do
  mount Tramway::Export::Engine, at: '/' if defined? Tramway::Export::Engine

  root to: 'welcome#index'

  resources :records
  resource :singleton, only: %i[new create show edit update]
  resources :has_and_belongs_to_many_records, only: %i[create destroy]
  resource :session, only: %i[new create]
  get 'sign_out', to: 'sessions#destroy'
end
