# frozen_string_literal: true

module Tramway
  module TramwayModelHelper
    def tramway_model?(model_class)
      model_class.ancestors.include? Tramway::ApplicationRecord
    end
  end
end
