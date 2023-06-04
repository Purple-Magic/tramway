# frozen_string_literal: true

# rubocop:disable Lint/MissingSuper
module Tailwinds
  module Navbar
    # Renders tailwind styled button using `button_to`
    #
    class ButtonComponent < ViewComponent::Base
      def initialize(text:, href:)
        @href = href
        @text = text
      end
    end
  end
end
# rubocop:enable Lint/MissingSuper
