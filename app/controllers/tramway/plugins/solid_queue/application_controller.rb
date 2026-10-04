# frozen_string_literal: true

require 'tramway/plugins'

module Tramway
  module Plugins
    module SolidQueue
      # Base controller for the solid_queue plugin dashboard
      class ApplicationController < Tramway.config.application_controller.constantize
        prepend_view_path "#{Gem::Specification.find_by_name('tramway').gem_dir}/app/views"

        layout 'tramway/layouts/application'

        helper Tramway::ApplicationHelper
        helper Tramway::Plugins::SolidQueue::JobsHelper
        include Rails.application.routes.url_helpers

        before_action :ensure_solid_queue_available!

        private

        def ensure_solid_queue_available!
          Tramway::Plugins.fetch(:solid_queue).ensure_available!
        end
      end
    end
  end
end
