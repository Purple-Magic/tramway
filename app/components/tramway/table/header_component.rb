# frozen_string_literal: true

module Tramway
  module Table
    # Component for rendering a header in a table
    class HeaderComponent < Tramway::BaseComponent
      include ContentCells

      option :headers, optional: true, default: -> { [] }
      option :columns, optional: true, default: -> { 3 }

      def columns_count(content = nil, parsed_cells: nil)
        return headers.size if headers.present?
        return parsed_cells.size if parsed_cells
        return visible_cells_from(content).size if content.present?

        columns
      end

      def header_row_classes
        'div-table-row grid grid-cols-1 gap-4 rounded-t-xl border-b border-zinc-800 bg-zinc-900 text-zinc-400'
      end

      def header_cell_classes
        'div-table-cell hidden px-6 py-4 first:block md:block'
      end
    end
  end
end
