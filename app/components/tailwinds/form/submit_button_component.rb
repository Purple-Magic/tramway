# frozen_string_literal: true

module Tailwinds
  module Form
    # Tailwind-styled submit button
    class SubmitButtonComponent < TailwindComponent
      def initialize(action, size: :middle, **options)
        @text = action.is_a?(String) ? action : action.to_s.capitalize

        super(
          input: nil,
          attribute: nil,
          value: nil,
          options: options.except(:type),
          label: nil,
          for: nil,
          size:,
        )
      end
    end
  end
end
