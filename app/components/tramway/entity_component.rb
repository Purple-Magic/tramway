# frozen_string_literal: true

module Tramway
  # Component for displaying an entity row in a list
  #
  class EntityComponent < Tramway::BaseComponent
    option :item
    option :entity

    def href
      if entity.pages.find { _1.action == 'show' }.present?
        Tramway::Engine.routes.url_helpers.public_send entity.routes.show, item.id
      else
        item.show_path
      end
    end

    def cells
      item.class.index_attributes.reduce({}) do |hash, attribute|
        hash.merge! attribute => item.public_send(attribute)
      end
    end
  end
end
