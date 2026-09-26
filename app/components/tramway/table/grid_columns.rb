# frozen_string_literal: true

module Tramway
  module Table
    # Builds the CSS grid template used by table rows/headers so that every
    # column keeps a minimum readable width. When the sum of those minimums
    # exceeds the viewport, the table overflows its scroll container instead
    # of hiding columns, giving mobile a full, horizontally scrollable table.
    module GridColumns
      MIN_COLUMN_WIDTHS = {
        small: '8rem',
        medium: '10rem',
        large: '12rem'
      }.freeze

      private

      def grid_template_class(columns_count)
        min_width = MIN_COLUMN_WIDTHS.fetch(tramway_table_size) { MIN_COLUMN_WIDTHS[:medium] }

        "grid-cols-[repeat(#{columns_count},minmax(#{min_width},1fr))]"
      end
    end
  end
end
