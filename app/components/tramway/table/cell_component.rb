# frozen_string_literal: true

module Tramway
  module Table
    # Component for rendering a cell in a table
    class CellComponent < Tramway::BaseComponent
      option :options, optional: true, default: -> { {} }

      def cell_classes
        'div-table-cell hidden px-6 py-4 text-base font-medium text-zinc-100 first:block md:block'
      end
    end
  end
end
