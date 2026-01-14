# frozen_string_literal: true

module Tailwinds
  module Nav
    # Base class for all Nav::ItemComponent classes
    #
    class ItemComponent < TailwindComponent
      def style
        @style ||= [
          theme_classes(
            classic: 'px-4 py-2 rounded-xl whitespace-nowrap hover:bg-gray-200 hover:text-gray-600 text-gray-700 ' \
                     'dark:text-gray-200 dark:hover:bg-gray-800 dark:hover:text-gray-300'
          )
        ].join(' ')
      end
    end
  end
end
