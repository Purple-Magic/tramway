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
          'absolute border border-zinc-800 w-full z-40 lef-0 rounded-md max-h-select overflow-y-auto ' \
            "bg-zinc-950 text-zinc-50 shadow-md ring-1 ring-zinc-800 #{SIZE_CLASSES[size]}"
        end
      end
    end
  end
end
