# frozen_string_literal: true

module Tailwinds
  # Table component for rendering a table
  class TableComponent < Tramway::Component::Base
    option :options, optional: true, default: -> { {} }
  end
end
