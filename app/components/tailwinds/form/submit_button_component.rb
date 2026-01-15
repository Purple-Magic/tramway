# frozen_string_literal: true

module Tailwinds
  module Form
    # Tailwind-styled submit button
    class SubmitButtonComponent < TailwindComponent
      def initialize(action, size: :medium, **options)
        unless size.in?(%i[small medium large])
          raise ArgumentError, "Invalid size: #{size}. Valid sizes are :small, :medium, :large."
        end

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
