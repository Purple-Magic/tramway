# frozen_string_literal: true

module Tailwinds
  module Form
    # Tailwind-styled submit button
    class SubmitButtonComponent < TailwindComponent
      def initialize(action, **options)
        @options = options.except :type

        @text = action.is_a?(String) ? action : action.to_s.capitalize
      end
    end
  end
end
