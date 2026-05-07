# frozen_string_literal: true

module Tramway
  module Form
    # Tailwind-styled checkbox field
    class CheckboxComponent < TailwindComponent
      def controller
        'tramway-checkbox'
      end

      def button_id
        "#{@for}_checkbox_button"
      end

      def button_classes
        theme_classes(
          classic: 'peer h-4 w-4 shrink-0 rounded-sm border border-zinc-800 bg-zinc-800/30 ' \
                   'ring-offset-zinc-950 focus-visible:outline-none focus-visible:ring-2 ' \
                   'focus-visible:ring-zinc-300 focus-visible:ring-offset-2 disabled:cursor-not-allowed ' \
                   'disabled:opacity-50 data-[state=checked]:border-zinc-50 data-[state=checked]:bg-zinc-50 ' \
                   'data-[state=checked]:text-zinc-950'
        )
      end

      def indicator_classes
        theme_classes(
          classic: 'flex items-center justify-center text-current hidden pointer-events-none'
        )
      end

      def icon_classes
        theme_classes(
          classic: 'h-4 w-4'
        )
      end

      def label_classes
        default_classes = 'text-sm font-medium leading-normal text-zinc-300 peer-disabled:cursor-not-allowed ' \
                          'peer-disabled:opacity-70 cursor-pointer'

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
