# frozen_string_literal: true

class Tramway::HasAndBelongsToManyRecordsController < ::Tramway::ApplicationController
  def create
    base_object = params[:model_class].constantize.find params[:object_id]
    form_class = params[:form].constantize
    record_form = form_class.new base_object
    sending_params = if params[params[:model_class].underscore].present?
                       params[params[:model_class].underscore]
                     else
                       params[form_class.associated_as]
                     end
    if record_form.submit sending_params
      redirect_to params[:redirect].present? ? params[:redirect] : record_path(base_object, model: base_object.class)
    else
      redirect_to params[:redirect].present? ? params[:redirect] : record_path(base_object, model: base_object.class)
    end
  end

  def destroy
    base_object = params[:model_class].constantize.find params[:object_id]
    record_form = params[:form].constantize.new base_object
    if record_form.submit params[:id]
      redirect_to params[:redirect].present? ? params[:redirect] : record_path(base_object, model: base_object.class)
    else
      redirect_to params[:redirect].present? ? params[:redirect] : record_path(base_object, model: base_object.class)
    end
  end
end
