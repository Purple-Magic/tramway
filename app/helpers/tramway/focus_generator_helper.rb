# frozen_string_literal: true

module ::Tramway::FocusGeneratorHelper
  # FIXME: create independent focus generator
  def focus_selector(index)
    "table:nth-child(2)>tbody>tr:nth-child(#{index - 1})"
  end
end
