# frozen_string_literal: true

module Tramway
  module Table
    module Row
      # Row component for rendering a row in a table
      class PreviewComponent < Tramway::BaseComponent
        def preview_classes
          theme_classes(
            classic: 'fixed hidden inset-x-0 bottom-0 shadow-lg z-50 bg-gray-100 animate-roll-up h-1/2'
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
