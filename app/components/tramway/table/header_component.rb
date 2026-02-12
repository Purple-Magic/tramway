# frozen_string_literal: true

module Tramway
  module Table
    # Component for rendering a header in a table
    class HeaderComponent < Tramway::BaseComponent
      option :headers, optional: true, default: -> { [] }

      def header_row_classes
        theme_classes(
          classic: 'div-table-row rounded-t-xl grid gap-4 bg-gray-800 text-gray-500 grid-cols-1'
        )
      end
    end
  end
end
