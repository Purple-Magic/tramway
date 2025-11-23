# frozen_string_literal: true

module Tramway
  module Utils
    # Provides helper method render that depends on ActionController::Base.render method
    #
    module Render
      def render(*, &)
        render_context = defined?(@view_context) && @view_context

        return render_context.render(*, &) if render_context

        ActionController::Base.render(*, &)
      end
    end
  end
end
