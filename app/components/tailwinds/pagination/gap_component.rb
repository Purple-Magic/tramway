# frozen_string_literal: true

module Tailwinds
  module Pagination
    # Kaminari gap component for rendering a gap in a pagination
    class GapComponent < Tramway::BaseComponent
      def gap_classes
        theme_classes(
          classic: 'page gap px-3 py-2 text-sm font-medium text-gray-400 sm:flex hidden'
        )
      end
    end
  end
end
