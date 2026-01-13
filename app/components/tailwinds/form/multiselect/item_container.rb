# frozen_string_literal: true

module Tailwinds
  module Form
    module Multiselect
      # Container for item in dropdown component
      class ItemContainer < Tramway::BaseComponent
        def item_classes
          theme_classes(
            classic: 'cursor-pointer w-full rounded-t border-b border-gray-700 hover:bg-gray-700',
            neomorphism: 'cursor-pointer w-full rounded-xl border-b border-gray-200 bg-gray-100 ' \
                         'hover:bg-gray-200 shadow-inner dark:bg-gray-900 dark:border-gray-700 ' \
                         'dark:hover:bg-gray-800'
          )
        end

        def item_inner_classes
          theme_classes(
            classic: 'flex w-full items-center p-2 pl-2 border-transparent border-l-2 relative hover:border-gray-600',
            neomorphism: 'flex w-full items-center p-2 pl-2 border-transparent border-l-2 relative ' \
                         'hover:border-gray-300 dark:hover:border-gray-600'
          )
        end

        def item_text_classes
          theme_classes(
            classic: 'w-full items-center flex dark:text-gray-100',
            neomorphism: 'w-full items-center flex text-gray-700 dark:text-gray-100'
          )
        end
      end
    end
  end
end
