# frozen_string_literal: true

module Tramway
  module Table
    # Component for rendering a header in a table
    class HeaderComponent < Tramway::BaseComponent
      include ContentCells
      include GridColumns

      SIZE_CLASSES = {
        small: {
          row: 'div-table-row tramway-data-table__head tramway-data-table__head--sm',
          cell: 'div-table-cell tramway-data-table__head-cell'
        },
        medium: {
          row: 'div-table-row tramway-data-table__head',
          cell: 'div-table-cell tramway-data-table__head-cell'
        },
        large: {
          row: 'div-table-row tramway-data-table__head tramway-data-table__head--lg',
          cell: 'div-table-cell tramway-data-table__head-cell'
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
