# frozen_string_literal: true

module Tramway
  module Form
    module TramwaySelect
      # Tailwind-styled tramway select field
      class SelectedItemTemplateComponent < Tramway::BaseComponent
        option :size
        option :multiple

        def selected_item_classes
          classes = 'tramway-select__chip selected-option cursor-pointer'
          classes += ' tramway-select__chip--bordered' if multiple
          classes
        end
      end
    end
  end
end
