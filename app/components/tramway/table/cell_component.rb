# frozen_string_literal: true

module Tramway
  module Table
    # Component for rendering a cell in a table
    class CellComponent < Tramway::BaseComponent
      def cell_classes
        theme_classes(
          classic: 'div-table-cell md:block first:block hidden p-4 align-middle text-sm text-zinc-200'
        )
      end
    end
  end
end
