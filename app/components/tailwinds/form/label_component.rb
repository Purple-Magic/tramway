# frozen_string_literal: true

module Tailwinds
  module Form
    # Form label for all tailwind-styled forms
    class LabelComponent < Tramway::BaseComponent
      option :for

      def form_label_classes
        theme_classes(
          classic: 'block text-sm font-bold mb-2 text-white',
          neomorphism: 'block text-sm font-semibold mb-2 text-gray-700'
        )
      end
    end
  end
end
