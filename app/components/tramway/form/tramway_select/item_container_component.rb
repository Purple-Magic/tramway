# frozen_string_literal: true

module Tramway
  module Form
    module TramwaySelect
      # Container for item in dropdown component
      class ItemContainerComponent < Tramway::BaseComponent
        option :size

        def item_classes
          'tramway-select__option option'
        end
      end
    end
  end
end
