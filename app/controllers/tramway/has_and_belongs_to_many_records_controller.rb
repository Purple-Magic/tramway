# frozen_string_literal: true

class Tramway::HasAndBelongsToManyRecordsController < ::Tramway::ApplicationController
  def create
    base_object = params[:model_class].constantize.find params[:object_id]
    form_class = params[:form].constantize
    @record_form = form_class.new base_object
    @sending_params = if params[params[:model_class].underscore].present?
                        params[params[:model_class].underscore]
                      else
                        params[form_class.associated_as]
                      end
    redirect_to path
  end

  def destroy
    base_object = params[:model_class].constantize.find params[:object_id]
    @record_form = params[:form].constantize.new base_object
    redirect_to path
  end

  private

  def path
    params[:redirect].present? ? params[:redirect] : record_path(base_object, model: base_object.class)
  end
end
