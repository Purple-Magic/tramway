# frozen_string_literal: true

module Tramway
  module Utils
    module Navbar
      # Provides helpers for navbar rendering
      #
      module Render
        def render_ignoring_block(text_or_url, url, options)
          options.merge!(href: url)
          render(Tailwinds::Nav::ItemComponent.new(**options)) { text_or_url }
        end

        def render_using_block(text_or_url, options, &block)
          options.merge!(href: text_or_url)
          render(Tailwinds::Nav::ItemComponent.new(**options), &block)
        end
      end
    end
  end
end
