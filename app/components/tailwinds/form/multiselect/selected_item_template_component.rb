# frozen_string_literal: true

module Tailwinds
  module Form
    module Multiselect
      # Tailwind-styled multi-select field
      class SelectedItemTemplateComponent < Tramway::BaseComponent
        def selected_item_classes
          theme_classes(
            classic: 'flex justify-center items-center m-1 font-medium py-1 px-2 rounded-full border ' \
                     'bg-teal-900 text-teal-100 border-teal-700 shadow-md'
          )
        end
      end
    end
  end
end
