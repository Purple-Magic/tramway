# frozen_string_literal: true

require 'tramway/plugins'

module Tramway
  module Configs
    # Value object stored at `Tramway.config.plugins`. It behaves like an array of
    # enabled plugin names (`config.plugins = [:solid_queue]`, `config.plugins.include?`,
    # `config.plugins.each`) while also exposing per-plugin configuration as attributes
    # (`config.plugins.solid_queue = { path: '/jobs' }`, `config.plugins.solid_queue`).
    class Plugins
      include Enumerable

      def initialize(names = [])
        @names = Array(names).map(&:to_sym)
        @configs = {}
      end

      def each(&block)
        return to_enum(:each) unless block

        @names.each(&block)
      end

      def include?(name)
        @names.include?(name.to_sym)
      end
      alias enabled? include?

      def to_a
        @names.dup
      end

      def method_missing(method_name, *args)
        plugin_name = plugin_name_from(method_name)

        return super unless plugin_name

        assignment?(method_name) ? assign_plugin_config(plugin_name, args.first) : plugin_config(plugin_name)
      end

      def respond_to_missing?(method_name, include_private = false)
        plugin_name_from(method_name).present? || super
      end

      private

      def plugin_name_from(method_name)
        name = method_name.to_s.delete_suffix('=').to_sym
        name if Tramway::Plugins.registered?(name)
      end

      def assignment?(method_name)
        method_name.to_s.end_with?('=')
      end

      def plugin_config(name)
        @configs[name] ||= Tramway::Plugins.fetch(name).config_class.new
      end

      def assign_plugin_config(name, options)
        @configs[name] = Tramway::Plugins.fetch(name).config_class.new(**(options || {}).symbolize_keys)
      end
    end
  end
end
