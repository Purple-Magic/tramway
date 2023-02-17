# frozen_string_literal: true

module Tramway::Associations::ObjectHelper
  def class_name(association)
    if association.polymorphic?
      object.send(association.name).class
    else
      unless association.options[:class_name]
        Tramway::Error.raise_error(
          :tramway, :associations, :object_helper, :please_specify_association_name,
          association_name: association.name, object_class: object.class,
          association_class_name: association.name.to_s.singularize.camelize
        )
      end
      association.options[:class_name]
    end
  end

  def check_association(object, association_name, association)
    return unless association.nil?

    Tramway::Error.raise_error(
      :tramway, :associations, :class_helper, :model_does_not_have_association,
      object_class: object.class, association_name:
    )
  end

  def association_type(association)
    association.class.to_s.split('::').last.sub(/Reflection$/, '').underscore.to_sym
  end

  def associations_collection(object, association_name, decorator_class_name)
    object.send(association_name).map do |association_object|
      decorator_class_name.decorate association_object
    end
  end

  def add_association_form_class_name(object, association_name)
    form_class = "Admin::#{object.class.to_s.pluralize}::Add#{association_name.to_s.camelize.singularize}Form"

    begin
      form_class.constantize
    rescue StandardError
      Tramway::Error.raise_error(
        :tramway, :associations, :object_helper, :habtm_add_class_not_defined,
        class: form_class, association_name:
      )
    end
  end

  def association_has_one_without_object(object, association_name, association_type)
    association_type == :has_one && object.send(association_name).nil?
  end

  def association_object(object, association_name)
    object.send association_name
  end
end
