# frozen_string_literal: true

module Tramway
  module Utils
    # Provides helper method render that depends on ActionController::Base.render method
    #
    module Render
      def render(*, &)
        ActionController::Base.render(*, &)
      end
    end
  end
end
