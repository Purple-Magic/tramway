# frozen_string_literal: true

class Tramway::HasAndBelongsToManyRecordsController < Tramway::ApplicationController
  def create
    base_object = model_class.find params[:object_id]
    @record_form = form_class.new base_object
    @sending_params = params[params[:model_class].underscore] || params[form_class.associated_as]
    redirect_to path
  end

  def destroy
    base_object = model_class.find params[:object_id]
    @record_form = params[:form].constantize.new base_object
    redirect_to path
  end

  private

  def path
    params[:redirect].present? ? params[:redirect] : record_path(base_object, model: base_object.class)
  end

  def form_class
    params[:form].constantize
  end
end
