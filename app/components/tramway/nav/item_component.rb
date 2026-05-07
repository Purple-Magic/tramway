# frozen_string_literal: true

module Tramway
  module Nav
    # Base class for all Nav::ItemComponent classes
    #
    class ItemComponent < TailwindComponent
      def style
        @style ||= 'inline-flex items-center rounded-md px-3 py-2 text-sm font-medium text-zinc-100 transition-colors hover:bg-zinc-800 hover:text-zinc-50'
      end
    end
  end
end
