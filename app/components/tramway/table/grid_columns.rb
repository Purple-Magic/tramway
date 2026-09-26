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

      # Matches the rem value of the row/header `gap-*` class for each size, so the
      # computed min-width below accounts for the gaps between grid tracks.
      GAP_WIDTHS_REM = {
        small: 0.5,
        medium: 1,
        large: 1.5
      }.freeze

      private

      # Column widths are set via an inline style (not a Tailwind class) because the class name
      # would be built dynamically from the columns count, and Tailwind's build only generates
      # utilities for class names it can find literally in the source.
      #
      # `min-width` is set to the full content width (all column minimums plus gaps) so that,
      # once the row/header no longer fits its container, the row's own box grows to match —
      # keeping its background and borders aligned with the horizontally scrolled columns
      # instead of clipping at the container's width.
      def grid_template_style(columns_count)
        size = tramway_table_size
        min_width = MIN_COLUMN_WIDTHS.fetch(size) { MIN_COLUMN_WIDTHS[:medium] }
        gap_width = GAP_WIDTHS_REM.fetch(size) { GAP_WIDTHS_REM[:medium] }
        total_min_width = (columns_count * min_width.to_f) + ([columns_count - 1, 0].max * gap_width)

        "grid-template-columns: repeat(#{columns_count}, minmax(#{min_width}, 1fr)); " \
          "min-width: #{total_min_width}rem"
      end
    end
  end
end
