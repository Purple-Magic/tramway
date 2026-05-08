# frozen_string_literal: true

module Tramway
  module Form
    # Tailwind-styled checkbox field
    class CheckboxComponent < TailwindComponent
      def checkbox_button_classes
        'peer h-4 w-4 shrink-0 rounded-sm border border-zinc-800 bg-zinc-950 text-zinc-50 ' \
          'ring-offset-zinc-950 ' \
          'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-zinc-300 ' \
          'focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 ' \
          'data-[state=checked]:border-zinc-50 data-[state=checked]:bg-zinc-50 ' \
          'data-[state=checked]:text-zinc-950'
      end

      def checkbox_indicator_classes
        'flex items-center justify-center text-current hidden'
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
        default_classes = 'cursor-pointer mb-0 leading-6'

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
