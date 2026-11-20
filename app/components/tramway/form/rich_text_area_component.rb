# frozen_string_literal: true

module Tramway
  module Form
    # Tailwind-styled rich text area
    class RichTextAreaComponent < TailwindComponent
      RICH_TEXT_AREA_CLASSES = %w[trix-content prose prose-invert tramway-form__rich-text].freeze

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
