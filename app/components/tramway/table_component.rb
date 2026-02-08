# frozen_string_literal: true

module Tramway
  # Table component for rendering a table
  class TableComponent < Tramway::BaseComponent
    option :options, optional: true, default: -> { {} }

    def table_classes
      theme_classes(
        classic: 'div-table text-left rtl:text-right text-gray-300'
      )
    end
  end
end
