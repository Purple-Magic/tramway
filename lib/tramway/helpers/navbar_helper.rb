# frozen_string_literal: true

require 'tramway/navbar'

module Tramway
  module Helpers
    # Providing navbar helpers for ActionView
    #
    module NavbarHelper
      def tramway_navbar(**options)
        if block_given?
          @navbar = Tramway::Navbar.new self

          yield @navbar

          options[:left_items] = @navbar.items[:left]
          options[:right_items] = @navbar.items[:right]
        end

        render(Tailwinds::NavbarComponent.new(**options))
      end
    end
  end
end
