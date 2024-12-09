# frozen_string_literal: true

module Tramway
  module Helpers
    # Provides a helper method `component` that allows to render components conveniently
    module ComponentHelper
      def component(name, *, **, &)
        render("#{name}_component".classify.constantize.new(*, **), &)
      end
    end
  end
end
