# frozen_string_literal: true

module Tailwinds
  module Pagination
    # Base component for rendering a Kaminari pagination
    class Base < Tramway::BaseComponent
      option :current_page
      option :url
      option :remote

      # :reek:UtilityFunction { enabled: false }
      def pagination_classes(klass: nil)
        default_classes = ['cursor-pointer', 'px-3', 'py-2', 'font-medium', 'text-purple-700', 'bg-white',
                           'rounded-md', 'hover:bg-purple-100', 'dark:text-white', 'dark:bg-gray-800',
                           'dark:hover:bg-gray-700']

        (default_classes + [klass]).join(' ')
      end
      # :reek:UtilityFunction { enabled: true }
    end
  end
end
