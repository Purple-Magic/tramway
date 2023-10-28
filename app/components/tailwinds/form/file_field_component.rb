# frozen_string_literal: true

module Tailwinds
  module Form
    # Tailwind-styled file_field input
    class FileFieldComponent < TailwindComponent
      def initialize(input, attribute, object_name: nil, **options)
        @label = options[:label] || attribute.to_s.capitalize
        @for = "#{object_name}_#{attribute}"
        @input = input
      end
    end
  end
end
