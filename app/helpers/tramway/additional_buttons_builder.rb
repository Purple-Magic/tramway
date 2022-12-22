# frozen_string_literal: true

module Tramway
  module AdditionalButtonsBuilder
    def build_button(button)
      options = button[:options] || {}
      style = 'margin-right: 8px'
      concat(link_to(button[:url], method: button[:method], class: "btn btn-#{button[:color]} btn-xs", style: style,
                                   **options) do
               button[:inner]&.call
             end)
    end
  end
end
