# frozen_string_literal: true

module Tramway
  # Table component for rendering a table
  class TableComponent < Tramway::BaseComponent
    option :options, optional: true, default: -> { {} }

    def table_classes
      'div-table w-full text-left rtl:text-right text-zinc-100'
    end
  end
end
