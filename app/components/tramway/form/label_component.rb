# frozen_string_literal: true

module Tramway
  module Form
    # Form label for all tailwind-styled forms
    class LabelComponent < Tramway::BaseComponent
      option :for
      option :options, optional: true, default: -> { {} }

      def form_label_classes
        theme_classes(
          classic: 'block font-semibold text-white'
        )
      end
    end
  end
end
