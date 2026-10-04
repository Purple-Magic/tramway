# frozen_string_literal: true

module Tramway
  module Plugins
    module SolidQueue
      # Per-plugin configuration for the `:solid_queue` plugin, set via
      # `Tramway.config.plugins.solid_queue = { path: '/jobs' }`.
      class Config < Dry::Struct
        attribute? :path, Types::Coercible::String.default('/jobs')
      end
    end
  end
end
