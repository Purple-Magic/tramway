# frozen_string_literal: true

module Tramway
  module Pagination
    # Base component for rendering a Kaminari pagination
    class Base < Tramway::BaseComponent
      option :current_page
      option :url
      option :remote

      def pagination_classes(klass: nil)
        default_classes = %w[
          inline-flex items-center justify-center h-10 px-3 py-2 rounded-md border border-zinc-800
          bg-zinc-950 text-sm font-medium text-zinc-100 shadow-sm transition-colors hover:bg-zinc-800
          hover:text-zinc-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-zinc-400
          focus-visible:ring-offset-2 focus-visible:ring-offset-zinc-950
        ]

        (default_classes + [klass]).join(' ')
      end
    end
  end
end
