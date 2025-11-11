# frozen_string_literal: true

module Tramway
  # Main controller for entities pages
  class EntitiesController < Tramway.config.application_controller.constantize
    prepend_view_path "#{Gem::Specification.find_by_name('tramway').gem_dir}/app/views"

    layout 'tramway/layouts/application'

    helper Tramway::ApplicationHelper
    include Rails.application.routes.url_helpers

    def index
      if index_scope.present?
        model_class.public_send(index_scope)
      else
        model_class.order(id: :desc)
      end.page(params[:page]) => entities

      @entities = entities

      case entity.permission.adapter
      when 'pundit'
        authorize @entities, policy_class: "#{model_class}Policy".constantize
      end

      @namespace = entity.namespace
    end

    def show
      @entity = tramway_decorate model_class.find(params[:id]), namespace: entity.namespace
    end

    private

    def model_class
      @model_class ||= params[:entity][:name].classify.constantize
    end

    def entity
      @entity ||= Tramway.config.entities.find { |e| e.name == params[:entity][:name] }
    end

    def index_scope
      entity.page(:index).scope
    end
  end
end
