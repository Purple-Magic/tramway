# frozen_string_literal: true

module Tramway
  module Views
    class FormBuilder < ActionView::Helpers::FormBuilder
      private

      def render(component, &)
        component.render_in(@template, &)
      end
    end
  end
end
