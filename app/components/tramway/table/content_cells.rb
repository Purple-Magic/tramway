# frozen_string_literal: true

module Tramway
  module Table
    # Helpers for extracting and normalizing visible table content cells from HTML fragments.
    module ContentCells
      private

      def visible_cells_from(content)
        fragment = Nokogiri::HTML.fragment(content)
        parsed_cells = fragment.xpath(
          './*[@class and contains(concat(" ", normalize-space(@class), " "), " div-table-cell ")]'
        )

        parsed_cells.each { |cell| remove_hidden_class!(cell) }
      end

      def remove_hidden_class!(node)
        classes = node['class'].to_s.split
        return if classes.empty?

        node['class'] = classes.reject { |class_name| class_name == 'hidden' }.join(' ')
      end
    end
  end
end
