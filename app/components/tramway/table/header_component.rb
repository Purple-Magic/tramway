# frozen_string_literal: true

module Tramway
  module Table
    # Component for rendering a header in a table
    class HeaderComponent < Tramway::BaseComponent
      include ContentCells
      include GridColumns

      SIZE_CLASSES = {
        small: {
          row: 'div-table-row grid gap-2 rounded-t-xl border-b border-zinc-800 bg-zinc-900 text-zinc-400',
          cell: 'div-table-cell truncate min-w-0 px-4 py-2'
        },
        medium: {
          row: 'div-table-row grid gap-4 rounded-t-xl border-b border-zinc-800 bg-zinc-900 text-zinc-400',
          cell: 'div-table-cell truncate min-w-0 px-6 py-4'
        },
        large: {
          row: 'div-table-row grid gap-6 rounded-t-xl border-b border-zinc-800 bg-zinc-900 text-zinc-400',
          cell: 'div-table-cell truncate min-w-0 px-6 py-6'
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

      def header_row_classes(columns_count)
        "#{size_classes.fetch(:row)} #{grid_template_class(columns_count)}"
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
