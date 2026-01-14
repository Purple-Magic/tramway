# frozen_string_literal: true

module Tailwinds
  module Form
    module Multiselect
      # Container for dropdown component
      class DropdownContainer < Tramway::BaseComponent
        def dropdown_classes
          theme_classes(
            classic: 'absolute shadow top-11 z-40 w-full lef-0 rounded-xl max-h-select overflow-y-auto ' \
                     'bg-gray-900 shadow-md ring-1 ring-gray-700'
          )
        end
      end
    end
  end
end
