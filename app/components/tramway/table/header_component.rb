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
        theme_classes(
          classic: 'div-table-row rounded-t-xl grid text-small gap-4 bg-gray-800 text-gray-500 grid-cols-1'
        )
      end

      def header_cell_classes
        'div-table-cell py-4 px-6 first:block hidden md:block'
      end
    end
  end
end
