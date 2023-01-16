# frozen_string_literal: true

module Tramway::FrontendHelper
  def react_params(form, action, method)
    form.properties.each_with_object({ action: react_params_url(form, action), method: method,
                                       authenticity_token: form_authenticity_token }) do |property, hash|
      case property[1]
      when :association
        hash.merge!(
          property[0] => {
            collection: build_collection_for_association(form, property[0])
          }
        )
      end
    end.merge model: form.model.attributes
  end

  def react_params_url(form, action)
    case action
    when :create
      Tramway::Engine.routes.url_helpers.records_path(model: form.model.class)
    else
      Tramway::Engine.routes.url_helpers.record_path(form.model.id, model: form.model.class)
    end
  end
end
