# frozen_string_literal: true

module Tramway
  module Form
    module TramwaySelect
      # Tailwind-styled tramway select field
      class SelectedItemTemplateComponent < Tramway::BaseComponent
        option :size
        option :multiple

        SIZE_CLASSES = {
          small: 'text-sm',
          medium: 'text-base',
          large: 'text-lg'
        }.freeze

        def selected_item_classes
          classes = 'flex justify-center items-center font-medium py-1 px-2 rounded-xl ' \
            'text-white shadow-md hover:bg-gray-800 cursor-pointer ' \
            'space-x-1 selected-option ' + SIZE_CLASSES[size].to_s

          if multiple
            classes += ' border border-gray-700'
          end

          theme_classes classic: classes
        end
      end
    end
  end
end
