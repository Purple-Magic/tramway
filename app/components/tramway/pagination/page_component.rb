# frozen_string_literal: true

module Tramway
  module Pagination
    # Kaminari page component for rendering a page button in a pagination
    class PageComponent < Tramway::Pagination::Base
      option :page

      def current_page_classes
        theme_classes(
          classic: 'inline-flex h-9 min-w-9 items-center justify-center rounded-md bg-zinc-50 px-3 py-2 ' \
                   'text-sm font-medium text-zinc-950 shadow-sm'
        )
      end
    end
  end
end
