# frozen_string_literal: true

Tramway::Engine.routes.draw do
  Tramway.config.entities.each do |entity|
    define_resource = lambda do |resource_name, entity| # rubocop:disable Lint/ShadowingOuterLocalVariable
      resources resource_name.pluralize.to_sym,
                only: [:index],
                controller: '/tramway/entities',
                defaults: { entity: }
    end

    if entity.name.include?('/')
      *namespaces, resource_name = entity.name.split('/')

      define_namespace = lambda do |index|
        namespace namespaces[index].to_sym do
          if namespaces[index] == namespaces.last
            define_resource.call(resource_name, entity)
          else
            define_namespace.call(namespaces[index + 1])
          end
        end
      end

      define_namespace.call(0)
    else
      define_resource.call(entity.name, entity)
    end
  end
end
