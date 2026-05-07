# frozen_string_literal: true

module Tramway
  module Table
    module Row
      # Row component for rendering a row in a table
      class PreviewComponent < Tramway::BaseComponent
        def preview_classes
          theme_classes(
            classic: 'fixed hidden md:hidden bottom-0 left-0 right-0 z-50 h-1/2 w-screen animate-roll-up ' \
                     'border-t border-zinc-800 bg-zinc-950 pt-4 shadow-lg'
          )
        end

        def close_button_classes
          theme_classes(
            classic: 'absolute top-4 right-4 text-zinc-500 hover:text-zinc-200'
          )
        end
      end
    end
  end
end
