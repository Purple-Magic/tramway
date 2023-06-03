module Tailwinds
  module Navbar
    class ButtonComponent < TailwindComponent
      def initialize(text:, href:)
        @href = href
        @text = text
      end
    end
  end
end
