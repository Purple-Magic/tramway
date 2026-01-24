# frozen_string_literal: true

module Tailwinds
  module Table
    # Component for rendering a cell in a table
    class CellComponent < Tramway::BaseComponent
      def cell_classes
        theme_classes(
          classic: 'div-table-cell md:block first:block hidden px-6 py-4 font-medium text-gray-100 text-base'
        )
      end
    end
  end
end
