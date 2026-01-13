# frozen_string_literal: true

module Tailwinds
  module Table
    # Component for rendering a cell in a table
    class CellComponent < Tramway::BaseComponent
      def cell_classes
        theme_classes(
          classic: 'div-table-cell md:block first:block hidden px-6 py-4 font-medium text-white text-base',
          neomorphism: 'div-table-cell md:block first:block hidden px-6 py-4 font-medium text-gray-700 text-base ' \
                       'dark:text-gray-100'
        )
      end

      def around_render
        ensure_view_context_accessor
        previous_flag = view_context.tramway_inside_cell
        view_context.tramway_inside_cell = true
        yield
      ensure
        view_context.tramway_inside_cell = previous_flag
      end

      private

      def ensure_view_context_accessor
        return if view_context.respond_to?(:tramway_inside_cell=)

        view_context.singleton_class.attr_accessor :tramway_inside_cell
      end
    end
  end
end
