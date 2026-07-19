# frozen_string_literal: true

module Tramway
  module Form
    # Tailwind-styled checkbox field
    class CheckboxComponent < TailwindComponent
      CHECKBOX_BUTTON_BASE_STYLES = {
        display: 'inline-flex',
        'align-items': 'center',
        'justify-content': 'center',
        padding: '0',
        'line-height': '1',
        'box-sizing': 'border-box'
      }.freeze

      CHECKBOX_BUTTON_SIZES = {
        small: '1rem',
        medium: '1.25rem',
        large: '1.5rem'
      }.freeze

      def checkbox_button_classes
        "peer #{size_class(:checkbox_input)} #{checkbox_base_classes} " \
          'data-[state=checked]:border-zinc-50 data-[state=checked]:bg-zinc-50 ' \
          'data-[state=checked]:text-zinc-950'
      end

      def checkbox_indicator_classes
        "flex hidden #{size_class(:checkbox_indicator)} items-center justify-center text-current"
      end

      def checkbox_button_style
        checkbox_button_style_attributes.map { |key, value| "#{key}: #{value}" }.join('; ')
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
        default_classes = 'cursor-pointer mb-0'

        case size
        when :small
          default_classes += ' text-sm leading-5'
        when :medium
          default_classes += ' text-base leading-6'
        when :large
          default_classes += ' text-lg leading-7'
        end

        default_classes
      end

      def label_style
        {
          'align-self': 'center',
          'line-height': checkbox_button_size,
          'margin-bottom': '0'
        }.map { |key, value| "#{key}: #{value}" }.join('; ')
      end

      private

      def checkbox_button_style_attributes
        CHECKBOX_BUTTON_BASE_STYLES.merge(
          width: checkbox_button_size,
          height: checkbox_button_size,
          'min-width': checkbox_button_size,
          'min-height': checkbox_button_size,
          'background-color': checked? ? '#fafafa' : '#09090b',
          color: checked? ? '#09090b' : '#fafafa'
        )
      end

      def checkbox_button_size
        CHECKBOX_BUTTON_SIZES.fetch(size, CHECKBOX_BUTTON_SIZES.fetch(:medium))
      end
    end
  end
end
