# frozen_string_literal: true

module Tramway
  module Table
    # Component for rendering a row in a table
    class RowComponent < Tramway::BaseComponent
      include ContentCells
      include GridColumns

      SIZE_CLASSES = {
        small: {
          row: 'div-table-row grid tramway-data-table__row tramway-data-table__row--sm',
          cell: 'div-table-cell tramway-data-table__cell tramway-data-table__cell--truncate ' \
                'tramway-data-table__cell--sm'
        },
        medium: {
          row: 'div-table-row grid tramway-data-table__row',
          cell: 'div-table-cell tramway-data-table__cell tramway-data-table__cell--truncate'
        },
        large: {
          row: 'div-table-row grid tramway-data-table__row tramway-data-table__row--lg',
          cell: 'div-table-cell tramway-data-table__cell tramway-data-table__cell--truncate ' \
                'tramway-data-table__cell--lg'
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
        'tramway-data-table__row--clickable'
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
