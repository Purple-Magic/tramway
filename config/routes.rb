# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Tramway::Engine.routes.draw do
  Tramway.config.entities.each do |entity|
    if entity.namespace.present?
      entity.namespace.split('/') + entity.name.split('/')
    else
      entity.name.split('/')
    end => segments

    resource_name = segments.pop

    default_resource_actions = %i[index create new show update destroy edit]

    project_routes_actions = Rails.application.routes.routes.map do |route|
      controller = route.defaults[:controller]&.split('/')&.last

      next unless controller == resource_name.pluralize

      route.defaults[:action]&.to_sym
    end.compact & default_resource_actions

    actions = (project_routes_actions + entity.pages.map { |page| page.action.to_sym }).uniq

    define_resource = proc do
      resources resource_name.pluralize.to_sym,
                only: actions,
                controller: '/tramway/entities',
                defaults: { entity: entity }
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
