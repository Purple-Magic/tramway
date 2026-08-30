# frozen_string_literal: true

module Tramway
  module Helpers
    # Provides size helpers for Tramway tables
    module TableHelper
      TABLE_SIZES = %i[small medium large].freeze

      def tramway_table_size
        context = tramway_table_context
        return :medium unless context&.respond_to?(:tramway_table_size)

        TABLE_SIZES.include?(context.tramway_table_size) ? context.tramway_table_size : :medium
      end

      def normalize_table_size(size)
        TABLE_SIZES.include?(size) ? size : :medium
      end

      def tramway_table_context
        return __vc_original_view_context if respond_to?(:__vc_original_view_context)
        return view_context if respond_to?(:view_context)
      end
    end
  end
end
