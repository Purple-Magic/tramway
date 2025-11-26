# frozen_string_literal: true

require 'tramway/helpers/routes_helper'

# rubocop:disable Metrics/BlockLength
Tramway::Engine.routes.draw do
  Tramway.config.entities.each do |entity|
    if entity.namespace.present?
      entity.namespace.split('/') + entity.name.split('/')
    else
      entity.name.split('/')
    end => segments

    resource_name = segments.pop

    define_resource = proc do
      entity.pages.each do |page|
        case page.action
        when 'index'
          get resource_name.pluralize, to: '/tramway/entities#index', defaults: { entity: }, as: resource_name.pluralize
        when 'show'
          get "#{resource_name.pluralize}/:id", to: '/tramway/entities#show', defaults: { entity: },
                                                as: resource_name.singularize
        end
      end
    end

    if segments.empty?
      define_resource.call
    else
      nest = lambda do |names|
        namespace names.first.to_sym do
          if names.size > 1
            nest.call(names.drop(1))
          else
            define_resource.call
          end
        end
      end

      nest.call(segments)
    end
  end
end
# rubocop:enable Metrics/BlockLength

Tramway::Engine.routes.routes.map(&:name).compact.each do |route_name|
  %w[path url].each do |suffix|
    Tramway::Helpers::RoutesHelper.define_route_helper("#{route_name}_#{suffix}")
  end
end
