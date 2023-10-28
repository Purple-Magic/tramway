# frozen_string_literal: true

module Tailwinds
  module Form
    # Tailwind-styled text field
    class TextFieldComponent < TailwindComponent
      def initialize(input, attribute, object_name: nil, **options)
        @label = options[:label] || attribute.to_s.humanize
        @for = "#{object_name}_#{attribute}"
        @input = input
      end
    end
  end
end
