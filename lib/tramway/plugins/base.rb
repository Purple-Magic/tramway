# frozen_string_literal: true

module Tramway
  module Plugins
    # Interface every Tramway plugin must implement to register itself with
    # `Tramway::Plugins.register` and be referenced from `Tramway.config.plugins`.
    class Base
      class << self
        def plugin_name
          raise NotImplementedError, "#{self} must implement .plugin_name"
        end

        def config_class
          raise NotImplementedError, "#{self} must implement .config_class"
        end

        def draw_routes(_mapper, _config)
          raise NotImplementedError, "#{self} must implement .draw_routes"
        end

        # Returns a Hash with :text, :path and :icon keys used to render a navbar entry
        # for this plugin, or nil to not render one.
        def nav_item(_config)
          nil
        end

        # Raises a clear, actionable error when the plugin's required infrastructure
        # (typically a gem) is missing. No-op by default.
        def ensure_available!; end
      end
    end
  end
end
