# frozen_string_literal: true

module Tramway
  module ExtendableFormsHelpers
    module PropertiesHelper
      def define_properties_method(simple_properties, more_properties)
        define_method 'properties' do
          hash = simple_properties.each_with_object({}) do |property, h|
            h.merge! property[0] => property[1] unless model.class.state_machines_names.include?(property[0])
          end
          more_properties.reduce(hash) do |h, property|
            h.merge! property[0] => {
              extended_form_property: property[1][:object]
            }
          end
        end
      end
    end
  end
end
