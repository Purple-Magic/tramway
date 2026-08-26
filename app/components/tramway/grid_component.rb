# frozen_string_literal: true

module Tramway
  # Dashboard-style grid container
  class GridComponent < Tramway::BaseComponent
    CELL_SIZE = '20em'

    option :rows
    option :columns
    option :outline, optional: true, default: -> { false }
    option :options, optional: true, default: -> { {} }

    def grid_classes
      theme_classes(
        classic: [
          'relative overflow-auto rounded-xl bg-zinc-950 shadow-inner',
          options[:class]
        ].compact.join(' ')
      )
    end

    def grid_shell_style
      return if rows.to_i <= 0 || columns.to_i <= 0

      "min-width: calc(#{columns.to_i} * #{CELL_SIZE}); min-height: calc(#{rows.to_i} * #{CELL_SIZE});"
    end

    def grid_net_style
      return if rows.to_i <= 0 || columns.to_i <= 0

      "grid-template-columns: repeat(#{columns.to_i}, #{CELL_SIZE}); grid-template-rows: repeat(#{rows.to_i}, #{CELL_SIZE});"
    end

    def grid_cells
      Array.new(rows.to_i) do |row_index|
        Array.new(columns.to_i) do |column_index|
          [row_index, column_index]
        end
      end
    end

    def grid_cell_classes(_row_index, _column_index)
      ['box-border', ('border border-zinc-800' if outline)].compact.join(' ')
    end

    def grid_cell_style
      "width: #{CELL_SIZE}; height: #{CELL_SIZE};"
    end
  end
end
