# frozen_string_literal: true

module Tramway::Core::ExtendableFormsHelpers::MorePropertiesHelper
  def define_property_method(property_name)
    define_method property_name do
      model.values[property_name] if model.values
    end
  end

  def define_assignment_method(property)
    define_method "#{property[0]}=" do |value|
      if property[1][:validates].present?
        property[1][:validates].each do |pair|
          make_validates property[0], pair, value
        end
      else
        model.values.merge property[0] => value
      end
    end
  end

  def define_file_property_assignment_method(property, field)
    define_method "#{property[0]}=" do |value|
      file_instance = property[1][:association_model].find_or_create_by(
        "#{model.class.name.underscore}_id" => model.id, "#{field.class.name.underscore}_id" => field.id
      )
      file_instance.file = value
      file_instance.save!
    end
  end
end
