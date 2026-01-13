# frozen_string_literal: true

module Tailwinds
  module Table
    # Component for rendering a header in a table
    class HeaderComponent < Tramway::BaseComponent
      option :headers, optional: true, default: -> { [] }
      option :columns, optional: true, default: -> { 3 }

      def columns_count
        headers.present? ? headers.size : columns
      end

      def header_row_classes
        theme_classes(
          classic: 'div-table-row grid text-small gap-4 bg-gray-700 text-gray-400 grid-cols-1',
          neomorphism: 'div-table-row rounded-t-xl grid text-small gap-4 bg-gray-200 text-gray-600 grid-cols-1 ' \
                       'dark:bg-gray-800 dark:text-gray-300'
        )
      end

      def header_cell_classes
        'div-table-cell py-4 px-6 first:block hidden md:block'
      end
    end
  end
end
