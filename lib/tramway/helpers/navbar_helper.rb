# frozen_string_literal: true

require 'tramway/navbar'

module Tramway
  module Helpers
    # Provides navbar helpers for ActionView
    module NavbarHelper
      def tramway_navbar(with_entities: true, **options)
        initialize_navbar(with_entities:)

        yield @navbar if block_given?

        assign_navbar_items(options)

        render_navbar_component(options)
      end

      private

      def initialize_navbar(with_entities:)
        @navbar = Tramway::Navbar.new self, with_entities:
      end

      def assign_navbar_items(options)
        navbar_items = @navbar.items
        navbar_items.each do |(key, value)|
          key_to_merge = case key
                         when :left, :right
                           :"#{key}_items"
                         else
                           key
                         end

          options.merge! key_to_merge => value
        end
      end

      def render_navbar_component(options)
        render(Tailwinds::NavbarComponent.new(**options))
      end
    end
  end
end
