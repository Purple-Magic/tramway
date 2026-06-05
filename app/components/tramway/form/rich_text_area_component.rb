# frozen_string_literal: true

module Tramway
  module Form
    # Tailwind-styled rich text area
    class RichTextAreaComponent < TailwindComponent
      RICH_TEXT_AREA_CLASSES = [
        'trix-content',
        'prose',
        'prose-invert',
        'max-w-none',
        'w-full',
        'min-h-40',
        'rounded-md',
        'border',
        'border-zinc-800',
        'bg-zinc-950',
        '!bg-zinc-950',
        'text-zinc-50',
        '!text-zinc-50',
        'shadow-sm',
        'transition-colors',
        'focus-visible:outline-none',
        'focus-visible:ring-2',
        'focus-visible:ring-zinc-300',
        'focus-visible:ring-offset-2',
        'focus-visible:ring-offset-zinc-950',
        'disabled:cursor-not-allowed',
        'disabled:opacity-50'
      ].freeze

      private

      def rich_text_area_options
        options.dup.tap do |rich_text_options|
          custom_class = rich_text_options.delete(:class) || rich_text_options.delete('class')
          rich_text_options[:class] = [RICH_TEXT_AREA_CLASSES, custom_class].compact.join(' ')
        end
      end
    end
  end
end
