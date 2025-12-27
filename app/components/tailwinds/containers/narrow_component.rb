# frozen_string_literal: true

module Tailwinds
  module Containers
    # Default page container in Tramway
    class NarrowComponent < Tramway::BaseComponent
      option :id, optional: true, default: proc { SecureRandom.uuid }
      option :theme, optional: true, default: -> { :dark }

      def color_classes
        case theme
        when :dark
          'bg-gray-900 text-white'
        when :light
          'bg-gray-100 text-gray-900'
        else
          'bg-gray-100 text-gray-900 dark:bg-gray-900 dark:text-white'
        end
      end
    end
  end
end
