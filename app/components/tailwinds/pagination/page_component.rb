# frozen_string_literal: true

module Tailwinds
  module Pagination
    # Kaminari page component for rendering a page button in a pagination
    class PageComponent < Tailwinds::Pagination::Base
      option :page

      def current_page_classes
        theme_classes(
          classic: 'px-3 py-2 font-medium rounded-md text-gray-800 bg-white',
          neomorphism: 'px-3 py-2 font-medium rounded-xl text-gray-700 bg-gray-200 shadow-inner ' \
                       'dark:bg-gray-700 dark:text-gray-100'
        )
      end
    end
  end
end
