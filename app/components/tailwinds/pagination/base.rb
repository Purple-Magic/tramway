# frozen_string_literal: true

module Tailwinds
  module Pagination
    # Base component for rendering a Kaminari pagination
    class Base < Tramway::BaseComponent
      option :current_page
      option :url
      option :remote

      def pagination_classes(klass: nil)
        default_classes = [
          'cursor-pointer', 'px-3', 'py-2', 'font-medium', 'rounded-md', 'text-white', 'bg-gray-800',
          'hover:bg-gray-700'
        ]

        (default_classes + [klass]).join(' ')
      end
    end
  end
end
