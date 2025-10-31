# frozen_string_literal: true

module Tailwinds
  module Table
    # Component for rendering a header in a table
    class HeaderComponent < Tramway::BaseComponent
      option :headers, optional: true, default: -> { [] }
      option :columns, optional: true, default: -> { 3 }

      def columns_count
        headers.present? ? headers.size : columns
      end
    end
  end
end
