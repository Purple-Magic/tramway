# frozen_string_literal: true

module Tailwinds
  module Pagination
    # Kaminari page component for rendering a page button in a pagination
    class PageComponent < Tailwinds::Pagination::Base
      option :page

      def current_page_classes
        theme_classes(
          classic: 'px-3 py-2 font-medium rounded-xl text-gray-100 bg-gray-700 shadow-inner'
        )
      end
    end
  end
end
