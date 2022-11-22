# frozen_string_literal: true

module Tramway::Inputs::PolymorphicAssociationsHelper
  def build_collection_for_polymorphic_association(form_object, property)
    user = defined?(current_user) ? current_user : current_admin
    object_names = full_class_names(form_object, property).map do |class_name|
      class_name.send("#{user.role}_scope", user.id).map do |obj|
        decorator_class(class_name).decorate obj
      end
    end.flatten
    object_names.sort_by { |obj| obj.name.to_s }
  end

  def build_value_for_polymorphic_association(form_object, property, value)
    if form_object.send(property).present?
      "#{form_object.send(property).class.to_s.underscore}_#{form_object.send(property).id}"
    elsif value[:type].present? && value[:id].present?
      "#{value[:type]&.underscore}_#{value[:id]}"
    end
  end

  def full_class_names(form_object, property)
    form_object.model.class.send("#{property}_type").values.map(&:constantize)
  end
end
