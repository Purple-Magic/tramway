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

      # Column widths are set via an inline style (not a Tailwind class) because the class name
      # would be built dynamically from the columns count, and Tailwind's build only generates
      # utilities for class names it can find literally in the source.
      def grid_template_style(columns_count)
        min_width = MIN_COLUMN_WIDTHS.fetch(tramway_table_size) { MIN_COLUMN_WIDTHS[:medium] }

        "grid-template-columns: repeat(#{columns_count}, minmax(#{min_width}, 1fr))"
      end
    end
  end
end
