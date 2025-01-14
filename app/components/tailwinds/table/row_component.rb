# frozen_string_literal: true

module Tailwinds
  module Table
    # Component for rendering a row in a table
    class RowComponent < Tramway::Component::Base
      option :cells, optional: true, default: -> { [] }
      option :href, optional: true

      def row_tag(**options, &)
        if href.present?
          klass = "#{options[:class] || ''} cursor-pointer dark:hover:bg-gray-700"

          link_to(href, options.merge(class: klass)) do
            yield if block_given?
          end
        else
          tag.div(**options) do
            yield if block_given?
          end
        end
      end
    end
  end
end
