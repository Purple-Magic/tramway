# frozen_string_literal: true

module Tramway
  module Form
    module TramwaySelect
      # Container for item in dropdown component
      class ItemContainerComponent < Tramway::BaseComponent
        option :size

        SIZE_CLASSES = {
          small: 'p-1',
          medium: 'p-2',
          large: 'p-3'
        }.freeze

        def item_classes
          "cursor-pointer rounded-sm text-zinc-50 hover:bg-zinc-900 option #{SIZE_CLASSES[size]}"
        end
      end
    end
  end
end
