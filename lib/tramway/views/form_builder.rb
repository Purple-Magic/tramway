# frozen_string_literal: true

module Tramway
  module Views
    # ActionView Form Builder helps us use ViewComponent as form helpers
    class FormBuilder < ActionView::Helpers::FormBuilder
      attr_reader :template

      private

      def render(component, &)
        component.render_in(template, &)
      end
    end
  end
end
