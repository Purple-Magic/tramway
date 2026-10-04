# frozen_string_literal: true

require 'tramway/errors'
require 'tramway/plugins/base'

module Tramway
  # Registry for Tramway plugins. A plugin is a class implementing the
  # `Tramway::Plugins::Base` interface, registered via `Tramway::Plugins.register`,
  # and referenced by name from `Tramway.config.plugins`.
  module Plugins
    module_function

    def registry
      @registry ||= {}
    end

    def register(plugin_class)
      registry[plugin_class.plugin_name.to_sym] = plugin_class
    end

    def registered?(name)
      registry.key?(name.to_sym)
    end

    def fetch(name)
      registry.fetch(name.to_sym) do
        raise Tramway::Errors::UnknownPluginError.new(name:, available: registry.keys)
      end
    end

    def each(&)
      registry.each(&)
    end
  end
end

require 'tramway/plugins/solid_queue'
