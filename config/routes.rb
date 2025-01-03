# frozen_string_literal: true

Tramway::Engine.routes.draw do
  Tramway.config.entities.each do |entity|
    resources entity.name.pluralize.to_sym, only: entity.pages, controller: :entities, defaults: { entity: entity.name }
  end
end
