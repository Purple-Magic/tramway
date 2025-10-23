# frozen_string_literal: true

module Tailwinds
  module Table
    # Component for rendering a row in a table
    class RowComponent < Tramway::Component::Base
      option :cells, optional: true, default: -> { [] }
      option :href, optional: true
      option :options, optional: true, default: -> { {} }

      def row_tag(**options, &)
        default_attributes = { role: :row }

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
        [
          'div-table-row', 'grid', 'gap-4', 'bg-white', 'border-b', 'last:border-b-0', 'dark:bg-gray-800',
          'dark:border-gray-700', "grid-cols-#{cells_count}"
        ].join(' ')
      end

      def link_row_classes
        'cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-700'
      end
    end
  end
end
