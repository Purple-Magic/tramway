# frozen_string_literal: true

module Tramway
  module Form
    # Form label for all tailwind-styled forms
    class LabelComponent < Tramway::BaseComponent
      option :for
      option :options, optional: true, default: -> { {} }

      def form_label_classes
        theme_classes(
          classic: 'mb-2 block text-sm font-medium leading-none text-zinc-300'
        )
      end
    end
  end
end
