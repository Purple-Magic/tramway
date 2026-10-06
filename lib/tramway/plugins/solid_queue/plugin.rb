# frozen_string_literal: true

module Tramway
  module Plugins
    module SolidQueue
      # Registry entry for the `:solid_queue` plugin — a Tramway-based dashboard for
      # SolidQueue jobs, queues and recurring tasks.
      class Plugin < Tramway::Plugins::Base
        class << self
          def plugin_name
            :solid_queue
          end

          def config_class
            Tramway::Plugins::SolidQueue::Config
          end

          def draw_routes(mapper, config)
            Tramway::Plugins::SolidQueue::Routes.draw(mapper, config)
          end

          def nav_item(config)
            { text: 'Background Jobs', path: config.path, icon: 'fa-tasks' }
          end

          def ensure_available!
            require 'solid_queue'
          rescue LoadError => e
            raise Tramway::Errors::MissingPluginDependencyError.new(
              plugin: plugin_name, gem_name: 'solid_queue', original_error: e
            )
          end
        end
      end
    end
  end
end
