# frozen_string_literal: true

class Tramway::ApplicationForm
  include Tramway::ApplicationForms::AssociationObjectHelpers
  include Tramway::ApplicationForms::ConstantObjectActions
  include Tramway::ApplicationForms::PropertiesObjectHelper
  include Tramway::ApplicationForms::ObjectHelpers
  include Tramway::ApplicationForms::SubmitHelper

  attr_accessor :submit_message

  def initialize(object = nil)
    tap do
      @object = object
      @@model_class = object.class
      @@enumerized_attributes = object.class.try :enumerized_attributes
      @@associations ||= []

      self.class.full_class_name_associations&.each do |association, class_name|
        define_association_method association, class_name
      end

      delegating object
    end
  end

  def model_name
    @@model_class.model_name
  end

  def associations
    @@associations
  end

  class << self
    include Tramway::ApplicationForms::AssociationClassHelpers
    include Tramway::ApplicationForms::ConstantClassActions
    include Tramway::ApplicationForms::Frontend

    delegate :defined_enums, to: :model_class

    def properties(*props)
      props.each { |prop| property prop }
    end

    def property(prop)
      @@properties ||= []
      @@properties << prop
      delegate prop, to: :model
      define_method("#{prop}=") do |value|
        model.send "#{prop}=", value
      end
    end

    def association(property)
      properties property
      @@associations = ((defined?(@@associations) && @@associations) || []) + [property]
    end

    def full_class_name_associations
      @@associations&.reduce({}) do |hash, association|
        options = @@model_class.reflect_on_all_associations(:belongs_to).select do |a|
          a.name == association.to_sym
        end.first&.options
        add_polymorphic_association hash, association, options
      end
    end

    def add_polymorphic_association(hash, association, options)
      if options&.dig(:polymorphic)
        hash.merge association => @@model_class.send("#{association}_type").values
      elsif options
        hash.merge(association => (options[:class_name] || association.to_s.camelize).constantize)
      else
        hash
      end
    end

    def full_class_name_association(association_name)
      full_class_name_associations[association_name]
    end

    def reflect_on_association(*args)
      @@model_class.reflect_on_association(*args)
    end

    def enumerized_attributes
      @@enumerized_attributes
    end

    def model_class
      if defined?(@@model_class) && @@model_class
        @@model_class
      else
        model_class_name ||= name.to_s.sub(/Form$/, '')
        begin
          @@model_class = model_class_name.constantize
        rescue StandardError
          Tramway::Error.raise_error :tramway, :application_form, :model_class, :there_is_not_model_class,
            name: name, model_class_name: model_class_name
        end
      end
    end

    def model_class=(name)
      @@model_class = name
    end

    def validates(attribute, **options)
      if !defined?(@@model_class) || @@model_class.nil?
        Tramway::Error.raise_error(:tramway, :application_form, :validates, :you_need_to_set_model_class)
      end
      @@model_class.validates attribute, **options
    end
  end

  private

  def collecting_associations_errors
    @@associations.each do |association|
      model.send("#{association}=", send(association)) if errors.details[association] == [{ error: :blank }]
    end
  end
end
