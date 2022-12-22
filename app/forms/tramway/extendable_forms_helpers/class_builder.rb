# frozen_string_literal: true

module Tramway
  module ExtendableFormsHelpers
    module ClassBuilder
      def build_form_class(name, simple_properties, more_properties)
        Object.const_set(name, Class.new(::Tramway::ApplicationForm) do
          properties(*simple_properties.keys) if simple_properties.keys.any?

          include Tramway::ExtendableFormsHelpers::Submit::ObjectHelpers
          include Tramway::ExtendableFormsHelpers::Validators
          extend Tramway::ExtendableFormsHelpers::Submit::ClassHelpers
          extend Tramway::ExtendableFormsHelpers::PropertiesHelper
          extend Tramway::ExtendableFormsHelpers::MorePropertiesHelper
          extend Tramway::ExtendableFormsHelpers::IgnoredPropertiesHelper

          define_submit_method simple_properties, more_properties
          define_properties_method simple_properties, more_properties
          define_ignored_properties_method

          more_properties.each do |property|
            define_property_method property[0]

            case property[1][:object].field_type
            when 'file'
              field = property[1][:object]
              define_file_property_assignment_method property, field
            else
              # next unless property[1][:validates].present?

              define_assignment_method property
            end
          end
        end)
      end
    end
  end
end
