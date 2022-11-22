# frozen_string_literal: true

module Tramway::Core::Inputs::AssociationsHelper
  def build_collection_for_association(form_object, property)
    user = defined?(current_user) ? current_user : current_admin
    full_class_name_association = form_object.class.full_class_name_association(property)
    check_valid_association full_class_name_association
    full_class_name_association.send("#{user.role}_scope", user.id).map do |obj|
      decorator_class(full_class_name_association).decorate obj
    end.sort_by do |association|
      association.name || "#{association.class.name} ##{association.id}"
    end
  end

  def build_value_for_association(form_object, property, value)
    form_object.send(property) || form_object.model.send("#{property}_id") || value
  end

  def check_valid_association(full_class_name_association)
    unless full_class_name_association
      Tramway::Error.raise_error(
        :tramway, :core, :inputs_helpers, :association_params, :defined_with_property_method, property: property
      )
    end
    return unless full_class_name_association.is_a? Array

    Tramway::Error.raise_error(
      :tramway, :core, :inputs_helpers, :association_params, :used_polymorphic_association, property: property
    )
  end
end
