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
      actions = entity.pages.reduce([]) do |acc, page|
        case page.action
        when 'index'
          acc << :index
        when 'show'
          acc << :show
        when 'create'
          acc + %i[create new]
        when 'update'
          acc + %i[edit update]
        when 'destroy'
          acc << :destroy
        else
          acc
        end
      end

      resources resource_name.pluralize.to_sym,
                only: actions.map(&:to_sym),
                controller: '/tramway/entities',
                defaults: { entity: }
    end

    if segments.empty?
      define_resource.call
    else
      nest = lambda do |names|
        namespace_name = names.first.to_sym
        namespace namespace_name do
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
