# frozen_string_literal: true

module Tramway
  module Nav
    # Base class for all Nav::ItemComponent classes
    #
    class ItemComponent < TailwindComponent
      def style
        @style ||= [
          theme_classes(
            classic: 'px-4 py-2 rounded-xl whitespace-nowrap hover:bg-gray-800 hover:text-gray-300 text-white'
          )
        ].join(' ')
      end
    end
  end
end
