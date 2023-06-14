# frozen_string_literal: true

module Tailwinds
  module Navbar
    # Render button styled with Tailwind using button_to or link_to methods
    #
    class ButtonComponent < TailwindComponent
      def initialize(**options)
        raise 'You should provide `action` or `href` option' if !options[:action].present? && !options[:href].present?

        if options[:action].present?
          @action = options[:action]
        else
          @href = options[:href]
        end

        @style = 'text-white hover:bg-red-300 px-4 py-2 rounded'
        @options = options.except(:action, :href)
      end
    end
  end
end
