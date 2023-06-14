# frozen_string_literal: true

module Tramway
  # Rails plugin is the Engine
  #
  class Engine < ::Rails::Engine
    isolate_namespace Tramway

    initializer 'tramway.load_helpers' do
      ActiveSupport.on_load(:action_view) do
        require 'tramway/helpers/tailwind_helpers'

        ActionView::Base.include Tramway::Helpers::TailwindHelpers
      end
    end
  end
end
