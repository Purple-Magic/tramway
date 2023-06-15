# frozen_string_literal: true

module Tramway
  module Helpers
    # ActionView helpers for tailwind
    #
    module TailwindHelpers
      def tailwind_link_to(text_or_url, url = nil, **options, &block)
        raise 'You can not provide argument and code block in the same time' if url.present? && block_given?

        if url.present?
          options.merge! href: url
          render(Tailwinds::Navbar::ButtonComponent.new(**options)) { text_or_url }
        else
          options.merge! href: text_or_url
          render(Tailwinds::Navbar::ButtonComponent.new(**options), &block)
        end
      end
    end
  end
end
