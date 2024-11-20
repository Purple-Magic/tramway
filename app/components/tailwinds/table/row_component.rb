# frozen_string_literal: true

module Tailwinds
  module Table
    # Component for rendering a row in a table
    class RowComponent < Tramway::Component::Base
      option :cells
    end
  end
end
