# frozen_string_literal: true

require 'tramway/helpers/routes_helper'
require 'tramway/plugins'

# rubocop:disable-next Metrics/BlockLength
Tramway::Engine.routes.draw do
  Tramway.config.entities.each do |entity|
    if entity.namespace.present?
      entity.namespace.split('/') + entity.name.split('/')
    else
      entity.name.split('/')
    end => segments

    resource_name = segments.pop
    controller_path = (segments + [resource_name.pluralize]).join('/')

    define_resource = proc do
      entity.built_in_pages.reduce([]) do |acc, page|
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
        end
      end => actions

      resources resource_name.pluralize.to_sym,
                only: actions.map(&:to_sym),
                controller: '/tramway/entities',
                defaults: { entity: } do
        entity.custom_pages.each do |page|
          path = ([page.action] + page.params.map { |param| ":#{param}" }).join('/')
          to = "/#{controller_path}##{page.action}"

          if page.member
            member { match path, to:, via: page.via, defaults: { entity: } }
          else
            collection { match path, to:, via: page.via, defaults: { entity: } }
          end
        end
      end
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

  Tramway.config.plugins.each do |plugin_name|
    plugin = Tramway::Plugins.fetch(plugin_name)
    plugin_config = Tramway.config.plugins.public_send(plugin_name)

    scope path: plugin_config.path do
      plugin.draw_routes(self, plugin_config)
    end
  end
end

Tramway::Engine.routes.routes.map(&:name).compact.each do |route_name|
  %w[path url].each do |suffix|
    Tramway::Helpers::RoutesHelper.define_route_helper("#{route_name}_#{suffix}")
  end
end
