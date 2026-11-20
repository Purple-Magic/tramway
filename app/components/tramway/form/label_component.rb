# frozen_string_literal: true

module Tramway
  module Form
    # Form label for all tailwind-styled forms
    class LabelComponent < Tramway::BaseComponent
      option :for
      option :options, optional: true, default: -> { {} }

      def form_label_classes
        'tramway-form__label'
      end
    end
  end
end
