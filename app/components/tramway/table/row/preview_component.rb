# frozen_string_literal: true

module Tramway
  module Table
    module Row
      # Row component for rendering a row in a table
      class PreviewComponent < Tramway::BaseComponent
        def preview_classes
          theme_classes(
            classic: 'fixed hidden md:hidden bottom-0 left-0 right-0 w-screen shadow-lg z-50 bg-gray-900 ' \
                     'animate-roll-up h-1/2 pt-4'
          )
        end

        def close_button_classes
          theme_classes(
            classic: 'absolute top-4 right-4 text-gray-500 hover:text-gray-700'
          )
        end
      end
    end
  end
end
