# frozen_string_literal: true

module Tailwinds
  module Containers
    class MainComponent < Tramway::BaseComponent
      def container_classes
        theme_classes(
          classic: 'bg-gray-900 text-white',
          neomorphism: 'bg-gray-100 text-gray-700 shadow-inner dark:bg-gray-900 dark:text-gray-100'
        )
      end
    end
  end
end
