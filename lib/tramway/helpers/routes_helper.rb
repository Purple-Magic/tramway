# frozen_string_literal: true

module Tramway
  module Helpers
    # Provides shortcut helpers that delegate to Tramway engine routes
    module RoutesHelper
      class << self
        def define_route_helper(method_name)
          define_method(method_name) do |*args, **kwargs, &block|
            Tramway::Engine.routes.url_helpers.public_send(method_name, *args, **kwargs, &block)
          end
        end
      end
    end
  end
end
