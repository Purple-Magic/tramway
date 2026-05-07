# frozen_string_literal: true

module Tramway
  module Nav
    # Base class for all Nav::ItemComponent classes
    #
    class ItemComponent < TailwindComponent
      def style
        @style ||= [
          theme_classes(
            classic: 'inline-flex h-9 items-center justify-center rounded-md px-4 py-2 text-sm font-medium ' \
                     'text-zinc-200 transition-colors hover:bg-zinc-800 focus-visible:outline-none ' \
                     'focus-visible:ring-1 focus-visible:ring-zinc-300 whitespace-nowrap'
          )
        ].join(' ')
      end
    end
  end
end
