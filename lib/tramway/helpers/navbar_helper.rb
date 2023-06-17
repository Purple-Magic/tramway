# frozen_string_literal: true

module Tramway
  module Helpers
    # Providing navbar helpers for ActionView
    #
    module NavbarHelper
      def tramway_navbar(**options)
        render(Tailwinds::NavbarComponent.new(**options))
      end
    end
  end
end
