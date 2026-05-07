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
          theme_classes(
            classic: "cursor-pointer transition-colors hover:bg-zinc-800 option #{SIZE_CLASSES[size]}"
          )
        end
      end
    end
  end
end
