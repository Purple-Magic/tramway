# frozen_string_literal: true

module Tramway
  # Component for displaying an entity row in a list
  #
  class EntityComponent < Tramway::BaseComponent
    option :item
    option :entity

    def decorated_item
      tramway_decorate item, namespace: entity.namespace
    end

    def href
      if entity.pages.find { _1.action == 'show' }.present?
        Tramway::Engine.routes.url_helpers.public_send entity.routes.show, decorated_item.id
      else
        decorated_item.show_path
      end
    end

    def cells
      decorated_item.class.index_attributes.reduce({}) do |hash, attribute|
        hash.merge! attribute => decorated_item.public_send(attribute)
      end
    end
  end
end
