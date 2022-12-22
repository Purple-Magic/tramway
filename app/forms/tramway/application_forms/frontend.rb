# frozen_string_literal: true

module Tramway::ApplicationForms::Frontend
  def react_component(on = false)
    @react_component = on
  end

  def react_component?
    @react_component ||= false
    @react_component
  end
end
