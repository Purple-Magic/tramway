# frozen_string_literal: true

module Tramway
  module Nav
    # Base class for all Nav::ItemComponent classes
    #
    class ItemComponent < TailwindComponent
      def style
        @style ||= 'inline-flex items-center rounded-md px-4 py-3 text-base font-medium text-zinc-100 ' \
                   'transition-colors hover:bg-zinc-800 hover:text-zinc-50 sm:px-3 sm:py-2 sm:text-sm'
      end
    end
  end
end
