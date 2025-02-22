# frozen_string_literal: true

module Tramway
  # Main controller for entities pages
  class EntitiesController < Tramway.config.application_controller.constantize
    prepend_view_path "#{Gem::Specification.find_by_name('tramway').gem_dir}/app/views"

    layout 'tramway/layouts/application'

    helper Tramway::ApplicationHelper
    include Rails.application.routes.url_helpers

    def index
      @entities = model_class.order(id: :desc).page(params[:page])
    end

    private

    def model_class
      @model_class ||= params[:entity][:name].classify.constantize
    end
  end
end
