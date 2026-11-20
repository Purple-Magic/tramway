# frozen_string_literal: true

module Tramway
  module Pagination
    # Base component for rendering a Kaminari pagination
    class Base < Tramway::BaseComponent
      option :current_page
      option :url
      option :remote

      def pagination_classes(klass: nil)
        ['tramway-pagination__link', klass].compact.join(' ')
      end
    end
  end
end
