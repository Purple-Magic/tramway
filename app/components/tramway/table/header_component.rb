# frozen_string_literal: true

module Tramway
  module Table
    # Component for rendering a header in a table
    class HeaderComponent < Tramway::BaseComponent
      include ContentCells

      SIZE_CLASSES = {
        small: {
          row: 'div-table-row grid grid-cols-1 gap-2 rounded-t-xl border-b border-zinc-800 bg-zinc-900 text-zinc-400',
          cell: 'div-table-cell hidden px-4 py-2 first:block md:block'
        },
        medium: {
          row: 'div-table-row grid grid-cols-1 gap-4 rounded-t-xl border-b border-zinc-800 bg-zinc-900 text-zinc-400',
          cell: 'div-table-cell hidden px-6 py-4 first:block md:block'
        },
        large: {
          row: 'div-table-row grid grid-cols-1 gap-6 rounded-t-xl border-b border-zinc-800 bg-zinc-900 text-zinc-400',
          cell: 'div-table-cell hidden px-6 py-6 first:block md:block'
        }
      }.freeze

      option :headers, optional: true, default: -> { [] }
      option :columns, optional: true, default: -> { 3 }
      option :options, optional: true, default: -> { {} }

      def columns_count(content = nil, parsed_cells: nil)
        return headers.size if headers.present?
        return parsed_cells.size if parsed_cells
        return visible_cells_from(content).size if content.present?

        columns
      end

      def header_row_classes
        size_classes.fetch(:row)
      end

      def header_cell_classes
        size_classes.fetch(:cell)
      end

      private

      def size_classes
        SIZE_CLASSES.fetch(tramway_table_size) { SIZE_CLASSES[:medium] }
      end
    end
  end
end
