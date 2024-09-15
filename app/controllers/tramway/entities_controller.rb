module Tramway
  class EntitiesController < Tramway.config.application_controller.constantize
    helper Tramway::ApplicationHelper

    def index
      @entities = model_class.page(params[:page])
    end

    private

    def model_class
      @model_class ||= params[:entity].classify.constantize
    end
  end
end
