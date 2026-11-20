# frozen_string_literal: true

module Tramway
  module Pagination
    # Kaminari gap component for rendering a gap in a pagination
    class GapComponent < Tramway::BaseComponent
      def gap_classes
        'page gap tramway-pagination__gap'
      end
    end
  end
end
