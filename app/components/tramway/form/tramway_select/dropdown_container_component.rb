# frozen_string_literal: true

module Tramway
  module Form
    module TramwaySelect
      # Container for dropdown component
      class DropdownContainerComponent < Tramway::BaseComponent
        option :size

        SIZE_CLASSES = {
          small: 'text-sm',
          medium: 'text-base',
          large: 'text-lg'
        }.freeze

        def dropdown_classes
          theme_classes(
            classic: 'absolute left-0 z-40 w-full overflow-hidden rounded-md border border-zinc-800 ' \
                     'bg-zinc-950 text-zinc-200 shadow-md max-h-select overflow-y-auto ' \
                     "#{SIZE_CLASSES[size]}"
          )
        end
      end
    end
  end
end
