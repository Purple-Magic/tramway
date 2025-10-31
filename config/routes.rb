# frozen_string_literal: true

Tramway::Engine.routes.draw do
  Tramway.config.entities.each do |entity|
    segments      = entity.name.split('/')
    resource_name = segments.pop

    define_resource = proc do
      resources resource_name.pluralize.to_sym,
                only: entity.pages.map(&:action),
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
