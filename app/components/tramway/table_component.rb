# frozen_string_literal: true

module Tramway
  # Table component for rendering a table
  class TableComponent < Tramway::BaseComponent
    TABLE_SIZES = %i[small medium large].freeze

    option :size, default: -> { :medium }
    option :options, optional: true, default: -> { {} }

    def table_classes
      'div-table w-full overflow-x-scroll tramway-scrollbar bg-zinc-950 text-left rtl:text-right text-zinc-100'
    end

    def around_render
      ensure_view_context_accessor
      context = tramway_table_context
      previous_size = context.tramway_table_size
      context.tramway_table_size = normalized_size

      yield
    ensure
      context.tramway_table_size = previous_size if context.respond_to?(:tramway_table_size=)
    end

    private

    def normalized_size
      TABLE_SIZES.include?(size) ? size : :medium
    end

    def ensure_view_context_accessor
      context = tramway_table_context
      return if context.respond_to?(:tramway_table_size=)

      context.singleton_class.attr_accessor :tramway_table_size
    end
  end
end
