# frozen_string_literal: true

module Tramway
  module Containers
    # Main container for tailwind-styled layout
    class MainComponent < Tramway::BaseComponent
      option :options, optional: true, default: proc { {} }

      def container_classes
        options_classes = options[:class] || ''

        theme_classes(
          classic: "bg-gray-900 text-gray-100 shadow-inner#{options_classes}"
        )
      end
    end
  end
end
