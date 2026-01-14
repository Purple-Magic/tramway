# frozen_string_literal: true

module Tailwinds
  module Containers
    # Default page container in Tramway
    class NarrowComponent < Tramway::BaseComponent
      option :id, optional: true, default: proc { SecureRandom.uuid }
      option :options, optional: true, default: proc { {} }

      def container_classes
        theme_classes(
          classic: 'container p-4 flex align-center justify-center w-full mx-auto bg-gray-100 text-gray-700 ' \
                   'shadow-inner rounded-xl dark:bg-gray-900 dark:text-gray-100'
        )
      end
    end
  end
end
