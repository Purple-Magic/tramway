# frozen_string_literal: true

module Tramway
  module Form
    module TramwaySelect
      # Container for dropdown component
      class DropdownContainerComponent < Tramway::BaseComponent
        option :size

        def dropdown_classes
          'tramway-select__dropdown'
        end
      end
    end
  end
end
