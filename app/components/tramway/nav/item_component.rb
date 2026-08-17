# frozen_string_literal: true

module Tramway
  module Nav
    # Base class for all Nav::ItemComponent classes
    #
    class ItemComponent < TailwindComponent
      def style
        @style ||= [
          'tramway-navbar-item inline-flex items-center rounded-md px-4 py-3 text-base font-medium text-zinc-100',
          'transition-colors hover:bg-zinc-800 hover:text-zinc-50 sm:px-3 sm:py-2 sm:text-sm'
        ].join(' ')
      end
    end
  end
end
