# frozen_string_literal: true

module Tramway::Core::ApplicationForms::AssociationObjectHelpers
  def define_association_method(association, class_name)
    if class_name.is_a? Array
      define_polymorphic_association association
    else
      self.class.send(:define_method, "#{association}=") do |value|
        model.send "#{association}_id=", value
        model.send "#{association}=", class_name.find(value)
      end
    end
  end

  def define_polymorphic_association(association)
    self.class.send(:define_method, "#{association}=") do |value|
      if value.present?
        if association_class(value).nil?
          Tramway::Error.raise_error :tramway, :core, :application_form, :initialize, :polymorphic_class_is_nil,
            association_name: association
        else
          model.send "#{association}=", association_class(value).find(value.split('_')[-1])
          send "#{association}_type=", association_class(value).to_s
        end
      end
    end
  end

  private

  def association_class(value)
    association_class_object = value.split('_')[0..-2].join('_').camelize
    association_class_object = association_class_object.constantize if association_class_object.is_a? String
    association_class_object
  end
end
