# frozen_string_literal: true

module Tramway::ModelHelper
  def tramway_model?(model_class)
    model_class.ancestors.include? Tramway::ApplicationRecord
  end
end
