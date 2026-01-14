# frozen_string_literal: true

module Tailwinds
  module Pagination
    # Base component for rendering a Kaminari pagination
    class Base < Tramway::BaseComponent
      option :current_page
      option :url
      option :remote

      def pagination_classes(klass: nil)
        default_classes = theme_classes(
          classic: [
            'cursor-pointer', 'px-3', 'py-2', 'font-medium', 'rounded-xl', 'text-gray-700', 'bg-gray-100',
            'shadow-md', 'hover:bg-gray-200', 'dark:bg-gray-800', 'dark:text-gray-200', 'dark:hover:bg-gray-700'
          ]
        )

        (default_classes + [klass]).join(' ')
      end
    end
  end
end
