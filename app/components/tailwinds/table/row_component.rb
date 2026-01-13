# frozen_string_literal: true

module Tailwinds
  module Table
    # Component for rendering a row in a table
    class RowComponent < Tramway::BaseComponent
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

      def desktop_row_classes(cells_count)
        theme_classes(
          classic: [
            'div-table-row', 'grid', 'gap-4', 'border-b', 'last:border-b-0', 'bg-gray-800',
            'border-gray-700', "md:grid-cols-#{cells_count}", 'grid-cols-1'
          ],
          neomorphism: [
            'div-table-row', 'grid', 'gap-4', 'border-b', 'last:border-b-0', 'bg-gray-100',
            'border-gray-200', "md:grid-cols-#{cells_count}", 'grid-cols-1',
            'dark:bg-gray-900', 'dark:border-gray-700'
          ]
        ).join(' ')
      end

      def link_row_classes
        theme_classes(
          classic: 'cursor-pointer hover:bg-gray-700',
          neomorphism: 'cursor-pointer hover:bg-gray-200 dark:hover:bg-gray-800'
        )
      end

      def cell_classes
        theme_classes(
          classic: 'div-table-cell px-6 py-4 font-medium text-white text-xs sm:text-base',
          neomorphism: 'div-table-cell px-6 py-4 font-medium text-gray-700 text-xs sm:text-base ' \
                       'dark:text-gray-100'
        )
      end
    end
  end
end
