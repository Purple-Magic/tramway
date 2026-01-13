# frozen_string_literal: true

module Tailwinds
  module Form
    module Multiselect
      # Tailwind-styled multi-select field
      class SelectedItemTemplate < Tramway::BaseComponent
        def selected_item_classes
          theme_classes(
            classic: 'flex justify-center items-center m-1 font-medium py-1 px-2 rounded-full border ' \
                     'bg-teal-900 text-teal-100 border-teal-700',
            neomorphism: 'flex justify-center items-center m-1 font-medium py-1 px-2 rounded-full border ' \
                         'bg-teal-100 text-teal-800 border-teal-200 shadow-md dark:bg-teal-900 ' \
                         'dark:text-teal-100 dark:border-teal-700'
          )
        end
      end
    end
  end
end
