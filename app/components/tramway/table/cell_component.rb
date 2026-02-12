# frozen_string_literal: true

module Tramway
  module Table
    # Component for rendering a cell in a table
    class CellComponent < Tramway::BaseComponent
      option :options, optional: true, default: -> { {} }

      def cell_classes
        theme_classes(
          classic: 'div-table-cell md:block first:block hidden sm:px-6 md:px-2 xl:px-6 py-4 font-medium text-gray-100'
        )
      end
    end
  end
end
