# frozen_string_literal: true

module Tramway::ExtendableFormsHelpers::Submit::ClassHelpers
  def define_submit_method(simple_properties, more_properties)
    define_method 'submit' do |params|
      model.values ||= {}
      extended_params = extended(simple_properties, more_properties, params)
      every_attribute_set params
      model.values = extended_params.reduce(model.values) do |hash, (key, value)|
        hash.merge! key => value
      end

      return unless model.errors.empty?

      save_in_submit params
    end
  end
end
