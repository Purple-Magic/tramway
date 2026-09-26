# frozen_string_literal: true

module Tramway
  module Table
    # Component for rendering a row in a table
    class RowComponent < Tramway::BaseComponent
      include ContentCells
      include GridColumns

      SIZE_CLASSES = {
        small: {
          row: 'div-table-row grid gap-2 border-b border-zinc-800 bg-transparent last:border-b-0',
          cell: 'div-table-cell truncate min-w-0 bg-transparent px-4 py-2 text-sm font-medium ' \
                'text-zinc-100 sm:text-sm'
        },
        medium: {
          row: 'div-table-row grid gap-4 border-b border-zinc-800 bg-transparent last:border-b-0',
          cell: 'div-table-cell truncate min-w-0 bg-transparent px-6 py-4 text-xs ' \
                'font-medium text-zinc-100 sm:text-base'
        },
        large: {
          row: 'div-table-row grid gap-6 border-b border-zinc-800 bg-transparent last:border-b-0',
          cell: 'div-table-cell truncate min-w-0 bg-transparent px-6 py-6 text-lg font-medium text-zinc-100'
        }
      }.freeze

      option :cells, optional: true, default: -> { [] }
      option :href, optional: true
      option :options, optional: true, default: -> { {} }

      def default_attributes
        { role: :row }
      end

      def row_tag(**options, &)
        if href.present?
          link_to(href, options.merge(class: "#{options[:class] || ''} #{link_row_classes}", **default_attributes)) do
            yield if block_given?
          end
        else
          tag.div(**options, **default_attributes) do
            yield if block_given?
          end
        end
      end

      def row_grid_classes
        size_classes.fetch(:row)
      end

      def link_row_classes
        'cursor-pointer hover:bg-zinc-900'
      end

      def cell_classes
        size_classes.fetch(:cell)
      end

      def around_render
        ensure_view_context_accessor
        context = tramway_table_context
        previous_flag = context.tramway_inside_cell
        context.tramway_inside_cell = href.present?

        yield
      ensure
        context.tramway_inside_cell = previous_flag if context.respond_to?(:tramway_inside_cell=)
      end

      private

      def ensure_view_context_accessor
        context = tramway_table_context
        return if context.respond_to?(:tramway_inside_cell=)

        context.singleton_class.attr_accessor :tramway_inside_cell
      end

      def size_classes
        SIZE_CLASSES.fetch(tramway_table_size) { SIZE_CLASSES[:medium] }
      end
    end
  end
end
