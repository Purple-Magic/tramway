# frozen_string_literal: true

module Tramway
  module Pagination
    # Kaminari gap component for rendering a gap in a pagination
    class GapComponent < Tramway::BaseComponent
      def gap_classes
        'page gap hidden items-center justify-center px-3 py-2 text-sm font-medium text-zinc-500 sm:flex'
      end
    end
  end
end
