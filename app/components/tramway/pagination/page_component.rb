# frozen_string_literal: true

module Tramway
  module Pagination
    # Kaminari page component for rendering a page button in a pagination
    class PageComponent < Tramway::Pagination::Base
      option :page

      def current_page_classes
        'inline-flex h-10 items-center justify-center rounded-md border border-zinc-800 bg-zinc-800 px-3 py-2 ' \
          'text-sm font-medium text-zinc-50 shadow-inner'
      end
    end
  end
end
