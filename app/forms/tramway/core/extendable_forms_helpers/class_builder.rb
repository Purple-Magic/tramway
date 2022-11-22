# frozen_string_literal: true

module Tramway::Core::ExtendableFormsHelpers::ClassBuilder
  def build_form_class(name, simple_properties, more_properties)
    Object.const_set(name, Class.new(::Tramway::Core::ApplicationForm) do
      properties(*simple_properties.keys) if simple_properties.keys.any?

      include Tramway::Core::ExtendableFormsHelpers::Submit::ObjectHelpers
      include Tramway::Core::ExtendableFormsHelpers::Validators
      extend Tramway::Core::ExtendableFormsHelpers::Submit::ClassHelpers
      extend Tramway::Core::ExtendableFormsHelpers::PropertiesHelper
      extend Tramway::Core::ExtendableFormsHelpers::MorePropertiesHelper
      extend Tramway::Core::ExtendableFormsHelpers::IgnoredPropertiesHelper

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
