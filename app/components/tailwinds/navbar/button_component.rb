# frozen_string_literal: true

module Tailwinds
  module Navbar
    # Render button styled with Tailwind
    #
    class ButtonComponent < TailwindComponent
      def initialize(text:, href:)
        @href = href
        @text = text
      end
    end
  end
end
