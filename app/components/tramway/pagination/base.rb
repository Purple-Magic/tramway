# frozen_string_literal: true

module Tramway
  module Pagination
    # Base component for rendering a Kaminari pagination
    class Base < Tramway::BaseComponent
      option :current_page
      option :url
      option :remote

      def pagination_classes(klass: nil)
        default_classes = theme_classes(
          classic: [
            'inline-flex', 'h-9', 'min-w-9', 'cursor-pointer', 'items-center', 'justify-center', 'rounded-md',
            'border', 'border-zinc-800', 'bg-zinc-950', 'px-3', 'py-2', 'text-sm', 'font-medium',
            'text-zinc-200', 'shadow-sm', 'transition-colors', 'hover:bg-zinc-800'
          ]
        )

        (default_classes + [klass]).join(' ')
      end
    end
  end
end
