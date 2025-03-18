# frozen_string_literal: true

module Tailwinds
  module Nav
    # Base class for all Nav::ItemComponent classes
    #
    class ItemComponent < TailwindComponent
      def style
        @style ||= [
          'text-white', 'hover:bg-gray-300', 'hover:text-gray-800', 'px-4', 'py-2', 'rounded', 'whitespace-nowrap',
          'dark:hover:bg-gray-700', 'dark:hover:text-gray-400', 'dark:text-white'
        ].join(' ')
      end
    end
  end
end
