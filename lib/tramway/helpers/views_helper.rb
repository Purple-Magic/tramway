# frozen_string_literal: true

module Tramway
  module Helpers
    # Provides view-oriented helpers for ActionView
    module ViewsHelper
      def tramway_form_for(object, *, size: :middle, **options, &)
        form_for(
          object,
          *,
          **options.merge(builder: Tailwinds::Form::Builder, size:),
          &
        )
      end

      def tramway_table(**options)
        component 'tailwinds/table', options:
      end

      def tramway_button(path:, text: nil, method: :get, **options)
        component 'tailwinds/button',
                  text:,
                  path:,
                  method:,
                  color: options.delete(:color),
                  type: options.delete(:type),
                  size: options.delete(:size),
                  options:
      end
    end
  end
end
