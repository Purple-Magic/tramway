module Tramway
  class EntitiesController < ActionController::Base
    def index
      @entities = params[:entity].classify.constantize.page(params[:page])
    end
  end
end
