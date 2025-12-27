# frozen_string_literal: true

module Tailwinds
  module Nav
    # Base class for all Nav::ItemComponent classes
    #
    class ItemComponent < TailwindComponent
      def style
        @style ||= [
          'px-4', 'py-2', 'rounded', 'whitespace-nowrap', 'hover:bg-gray-700', 'hover:text-gray-400', 'text-white'
        ].join(' ')
      end
    end
  end
end
