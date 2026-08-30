# frozen_string_literal: true

module Tramway
  module Table
    # Component for rendering a cell in a table
    class CellComponent < Tramway::BaseComponent
      SIZE_CLASSES = {
        small: 'div-table-cell hidden bg-transparent px-4 py-2 text-sm font-medium text-zinc-100 first:block md:block',
        medium: 'div-table-cell hidden bg-transparent px-6 py-4 text-base font-medium ' \
                'text-zinc-100 first:block md:block',
        large: 'div-table-cell hidden bg-transparent px-6 py-6 text-lg font-medium ' \
               'text-zinc-100 first:block md:block'
      }.freeze

      option :options, optional: true, default: -> { {} }

      def cell_classes
        SIZE_CLASSES.fetch(tramway_table_size) { SIZE_CLASSES[:medium] }
      end
    end
  end
end
