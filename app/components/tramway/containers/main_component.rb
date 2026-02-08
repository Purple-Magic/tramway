# frozen_string_literal: true

module Tramway
  module Containers
    # Main container for tailwind-styled layout
    class MainComponent < Tramway::BaseComponent
      def container_classes
        theme_classes(
          classic: 'bg-gray-900 text-gray-100 shadow-inner'
        )
      end
    end
  end
end
