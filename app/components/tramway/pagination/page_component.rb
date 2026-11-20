# frozen_string_literal: true

module Tramway
  module Pagination
    # Kaminari page component for rendering a page button in a pagination
    class PageComponent < Tramway::Pagination::Base
      option :page

      def current_page_classes
        'tramway-pagination__link tramway-pagination__link--current'
      end
    end
  end
end
