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
    end
  end
end
