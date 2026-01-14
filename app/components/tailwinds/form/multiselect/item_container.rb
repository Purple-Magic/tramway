# frozen_string_literal: true

module Tailwinds
  module Form
    module Multiselect
      # Container for item in dropdown component
      class ItemContainer < Tramway::BaseComponent
        def item_classes
          theme_classes(
            classic: 'cursor-pointer w-full rounded-xl border-b border-gray-700 bg-gray-900 ' \
                     'hover:bg-gray-800 shadow-inner'
          )
        end

        def item_inner_classes
          theme_classes(
            classic: 'flex w-full items-center p-2 pl-2 border-transparent border-l-2 relative ' \
                     'hover:border-gray-600'
          )
        end

        def item_text_classes
          theme_classes(
            classic: 'w-full items-center flex text-gray-100'
          )
        end
      end
    end
  end
end
