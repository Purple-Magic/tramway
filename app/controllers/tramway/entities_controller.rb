# frozen_string_literal: true

module Tramway
  # Main controller for entities pages
  class EntitiesController < Tramway.config.application_controller.constantize
    prepend_view_path "#{Gem::Specification.find_by_name('tramway').gem_dir}/app/views"

    layout 'tramway/layouts/application'

    helper Tramway::ApplicationHelper
    include Rails.application.routes.url_helpers

    def index
      @entities = if entity.page(:index).scope.present?
                    model_class.public_send(entity.page(:index).scope)
                  else
                    model_class.order(id: :desc)
                  end.page(params[:page])

      @namespace = entity.route&.namespace
    end

    private

    def model_class
      @model_class ||= params[:entity][:name].classify.constantize
    end

    def entity
      @entity ||= Tramway.config.entities.find { |e| e.name == params[:entity][:name] }
    end
  end
end
