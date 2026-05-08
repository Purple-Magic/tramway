# frozen_string_literal: true

module Tramway
  module Form
    # Form label for all tailwind-styled forms
    class LabelComponent < Tramway::BaseComponent
      option :for
      option :options, optional: true, default: -> { {} }

      def form_label_classes
        'block text-sm font-medium leading-none mb-2 text-zinc-200 peer-disabled:cursor-not-allowed ' \
          'peer-disabled:opacity-70'
      end
    end
  end
end
