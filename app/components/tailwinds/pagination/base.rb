# frozen_string_literal: true

module Tailwinds
  module Pagination
    class Base < Tramway::Component::Base
      option :current_page
      option :url
      option :remote

      def pagination_classes(klass: nil)
        "cursor-pointer px-3 py-2 font-medium text-purple-700 bg-white rounded-md hover:bg-purple-100 dark:text-white dark:bg-gray-800 dark:hover:bg-gray-700 #{klass}"
      end
    end
  end
end
