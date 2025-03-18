# frozen_string_literal: true

module Tailwinds
  module Table
    # Component for rendering a row in a table
    class RowComponent < Tramway::Component::Base
      option :cells, optional: true, default: -> { [] }
      option :href, optional: true
      option :options, optional: true, default: -> { {} }

      def row_tag(**options, &)
        if href.present?
          klass = "#{options[:class] || ''} #{link_row_classes}"

          link_to(href, options.merge(class: klass)) do
            yield if block_given?
          end
        else
          tag.div(**options) do
            yield if block_given?
          end
        end
      end

      # :reek:UtilityFunction { enabled: false }
      def desktop_row_classes(cells_count)
        [
          'div-table-row', 'grid', 'gap-4', 'bg-white', 'border-b', 'last:border-b-0', 'dark:bg-gray-800',
          'dark:border-gray-700', "grid-cols-#{cells_count}"
        ].join(' ')
      end
      # :reek:UtilityFunction { enabled: true }

      def link_row_classes
        'cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-700'
      end
    end
  end
end
