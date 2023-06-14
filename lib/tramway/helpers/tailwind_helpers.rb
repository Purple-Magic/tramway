# frozen_string_literal: true

module Tramway
  module Helpers
    # ActionView helpers for tailwind
    #
    module TailwindHelpers
      def tailwind_clickable(text = nil, **options, &block)
        raise 'You can not provide argument and code block in the same time' if text.present? && block_given?
        raise 'You should provide `action` or `href` option' if !options[:action].present? && !options[:href].present?

        if text.present?
          render(Tailwinds::Navbar::ButtonComponent.new(**options)) { text }
        else
          render(Tailwinds::Navbar::ButtonComponent.new(**options), &block)
        end
      end

      alias tailwind_button_to tailwind_clickable
      alias tailwind_link_to tailwind_clickable
    end
  end
end
