# frozen_string_literal: true

module Tramway
  module Form
    # Tailwind-styled checkbox field
    class CheckboxComponent < TailwindComponent
      def label_classes
        default_classes = 'cursor-pointer mb-0'

        case size
        when :small
          default_classes += ' text-sm'
        when :medium
          default_classes += ' text-base'
        when :large
          default_classes += ' text-lg'
        end

        default_classes
      end
    end
  end
end
