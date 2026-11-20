# frozen_string_literal: true

module Tramway
  module Table
    # Component for rendering a cell in a table
    class CellComponent < Tramway::BaseComponent
      SIZE_CLASSES = {
        small: 'div-table-cell tramway-data-table__cell tramway-data-table__cell--sm',
        medium: 'div-table-cell tramway-data-table__cell',
        large: 'div-table-cell tramway-data-table__cell tramway-data-table__cell--lg'
      }.freeze

      option :options, optional: true, default: -> { {} }
      option :truncate, optional: true, default: -> { true }

      def cell_classes
        base_classes = SIZE_CLASSES.fetch(tramway_table_size) { SIZE_CLASSES[:medium] }
        truncate ? "#{base_classes} tramway-data-table__cell--truncate" : base_classes
      end
    end
  end
end
