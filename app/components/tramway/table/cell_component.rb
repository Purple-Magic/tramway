# frozen_string_literal: true

module Tramway
  module Table
    # Component for rendering a cell in a table
    class CellComponent < Tramway::BaseComponent
      SIZE_CLASSES = {
        small: 'div-table-cell min-w-0 bg-transparent px-4 py-2 text-sm font-medium text-zinc-100',
        medium: 'div-table-cell min-w-0 bg-transparent px-6 py-4 text-base font-medium text-zinc-100',
        large: 'div-table-cell min-w-0 bg-transparent px-6 py-6 text-lg font-medium text-zinc-100'
      }.freeze

      option :options, optional: true, default: -> { {} }
      option :truncate, optional: true, default: -> { true }

      def cell_classes
        base_classes = SIZE_CLASSES.fetch(tramway_table_size) { SIZE_CLASSES[:medium] }
        truncate ? "#{base_classes} truncate" : base_classes
      end
    end
  end
end
