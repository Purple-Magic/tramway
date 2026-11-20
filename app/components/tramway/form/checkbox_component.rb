# frozen_string_literal: true

module Tramway
  module Form
    # Tailwind-styled checkbox field. The `ui--checkbox` Stimulus controller keeps `data-state`,
    # `aria-checked` and the indicator in sync; all visuals come from `.tramway-form__check-input`.
    class CheckboxComponent < TailwindComponent
      def checkbox_button_classes
        checkbox_classes
      end

      def container_classes
        return 'tramway-form__check tramway-form__field--horizontal' if options[:horizontal]

        'tramway-form__check'
      end

      def checked?
        !!ActiveModel::Type::Boolean.new.cast(options.fetch(:checked, value))
      end

      def hidden_checkbox_options
        options.merge(
          id: hidden_checkbox_id,
          class: 'hidden',
          data: options.fetch(:data, {}).merge('ui--checkbox-target' => 'input'),
          tabindex: -1,
          aria: { hidden: true }
        )
      end

      def hidden_checkbox_id
        "#{@for}_input"
      end

      def label_classes
        'tramway-form__check-label'
      end
    end
  end
end
