# frozen_string_literal: true

module Tramway
  # Rails plugin is the Engine
  #
  class Engine < ::Rails::Engine
    isolate_namespace Tramway

    initializer 'tramway.load_helpers' do
      ActiveSupport.on_load(:action_view) do |loaded_class|
        require 'tramway/helpers/navbar_helper'

        loaded_class.include Tramway::Helpers::NavbarHelper
      end

      ActiveSupport.on_load(:action_controller) do |loaded_class|
        require 'tramway/helpers/decorate_helper'

        loaded_class.include Tramway::Helpers::DecorateHelper
      end

      ActiveSupport.on_load(:action_controller) do |loaded_class|
        require 'tramway/helpers/form_helper'

        loaded_class.include Tramway::Helpers::FormHelper
      end
    end
  end
end
