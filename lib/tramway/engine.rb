# frozen_string_literal: true

require 'font-awesome-rails'

module Tramway
  # Rails plugin is the Engine
  #
  class Engine < ::Rails::Engine
    isolate_namespace Tramway

    initializer 'tramway.load_helpers' do
      load_navbar_helper
      load_views_helper
      load_decorator_helper
      load_form_helper
      load_routes_helper
      load_chats_broadcast
      load_searchable
    end

    initializer 'tramway.assets.precompile' do |app|
      font_awesome_font_paths.each do |path|
        path_string = path.to_s
        app.config.assets.paths << path_string unless app.config.assets.paths.include?(path_string)
      end

      app.config.assets.precompile += %w[
        tramway/tramway.js
        font-awesome.css
      ]
    end

    private

    def load_navbar_helper
      ActiveSupport.on_load(:action_view) do |loaded_class|
        require 'tramway/helpers/navbar_helper'

        loaded_class.include Tramway::Helpers::NavbarHelper
      end
    end

    def load_views_helper
      ActiveSupport.on_load(:action_view) do |loaded_class|
        require 'tramway/helpers/views_helper'

        loaded_class.include Tramway::Helpers::ViewsHelper
      end
    end

    def load_decorator_helper
      ActiveSupport.on_load(:action_controller) do |loaded_class|
        require 'tramway/helpers/decorate_helper'

        loaded_class.include Tramway::Helpers::DecorateHelper
      end
    end

    def load_form_helper
      ActiveSupport.on_load(:action_controller) do |loaded_class|
        require 'tramway/helpers/form_helper'

        loaded_class.include Tramway::Helpers::FormHelper
      end
    end

    def load_routes_helper
      ActiveSupport.on_load(:action_controller) do |loaded_class|
        require 'tramway/helpers/routes_helper'

        loaded_class.include Tramway::Helpers::RoutesHelper
      end

      ActiveSupport.on_load(:action_view) do |loaded_class|
        require 'tramway/helpers/routes_helper'

        loaded_class.include Tramway::Helpers::RoutesHelper
      end
    end

    def load_chats_broadcast
      ActiveSupport.on_load(:action_controller) do |loaded_class|
        loaded_class.include Tramway::Chats::Broadcast
      end

      ActiveSupport.on_load(:active_record) do |loaded_class|
        loaded_class.include Tramway::Chats::Broadcast
      end
    end

    def load_searchable
      ActiveSupport.on_load(:active_record) do |loaded_class|
        require 'tramway/searchable'

        loaded_class.include Tramway::Searchable
      end
    end

    def font_awesome_font_paths
      [FontAwesome::Rails::Engine.root.join('app/assets/fonts')]
    end

    def configure_pagination
      ActiveSupport.on_load(:action_controller) do
        # Detecting tramway views path
        tramway_spec = Gem.loaded_specs['tramway']
        tramway_views_path = File.join(tramway_spec.full_gem_path, 'app/views')

        paths = view_paths.to_ary

        # Determine index to insert tramway views path
        rails_views_index = paths.find_index { |path| path.to_s.ends_with?('app/views') }
        insert_index = rails_views_index ? rails_views_index + 1 : 0

        # Inserting tramway views path
        paths.insert(insert_index, tramway_views_path)
        self.view_paths = paths
      end
    end
  end
end
