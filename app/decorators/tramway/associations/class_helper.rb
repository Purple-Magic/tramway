# frozen_string_literal: true

module Tramway::Associations::ClassHelper
  def decorate_association(association_name, decorator: nil, as: nil, state_machines: [])
    @@decorated_associations ||= []
    @@decorated_associations << association_name

    define_main_association_method association_name, decorator

    define_method "#{association_name}_as" do
      as
    end

    define_method "#{association_name}_state_machines" do
      state_machines
    end

    define_method "add_#{association_name}_form" do
      add_association_form_class_name(object, association_name).new object
    end
  end

  def decorate_associations(*association_names)
    association_names.each do |association_name|
      decorate_association association_name
    end
  end

  def define_main_association_method(association_name, decorator)
    define_method association_name do
      association = object.class.reflect_on_association(association_name)
      type = association_type(association)
      return if association_has_one_without_object(object, association_name, type)

      check_association object, association_name, association
      decorator_class_name = decorator || decorator_class_name(class_name(association))
      case type
      when :has_many, :has_and_belongs_to_many
        associations_collection(object, association_name, decorator_class_name)
      when :belongs_to, :has_one
        decorator_class_name.decorate(association_object(object, association_name))
      end
    end
  end
end
