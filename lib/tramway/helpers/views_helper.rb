# frozen_string_literal: true

module Tramway
  module Helpers
    # Provides view-oriented helpers for ActionView
    module ViewsHelper
      def tramway_form_for(object, *args, **options, &)
        form_for(object, *args, **options.merge(builder: Tailwinds::Form::Builder), &)
      end

      def tailwind_submit_button(action, **options)
        render Tailwinds::Form::SubmitButtonComponent.new(action, **options)
      end
    end
  end
end
