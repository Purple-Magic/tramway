# frozen_string_literal: true

module Tramway::InputsHelper
  include Tramway::Inputs::AssociationsHelper
  include Tramway::Inputs::PolymorphicAssociationsHelper

  def association_params(form_object:, property:, value:, object:, options: {})
    full_class_name_association = form_object.class.full_class_name_association(property)

    if full_class_name_association.to_s == 'Tramway::User'
      user = defined?(current_user) ? current_user : current_admin
      value = user.id
    end

    build_input_attributes(object: object, property: property, options: options,
                           value: build_value_for_association(form_object, property, value),
                           collection: build_collection_for_association(form_object, property),
                           include_blank: true,
                           selected: form_object.model.send("#{property}_id") || value)
  end

  def polymorphic_association_params(object:, form_object:, property:, value:, options: {})
    build_input_attributes object: object, property: property,
                           selected: build_value_for_polymorphic_association(form_object, property, value),
                           value: build_value_for_polymorphic_association(form_object, property, value),
                           collection: build_collection_for_polymorphic_association(form_object, property),
                           options: options.merge(
                             as: :select,
                             include_blank: true,
                             label_method: ->(obj) { "#{obj.class.model_name.human} | #{obj.name}" },
                             value_method: lambda { |obj|
                               "#{obj.class.to_s.underscore.sub(/_decorator$/, '')}_#{obj.id}"
                             }
                           )
  end

  def build_input_attributes(**options)
    {
      label: false,
      input_html: {
        name: "#{options[:object]}[#{options[:property]}]",
        id: "#{options[:object]}_#{options[:property]}",
        value: options[:value]
      },
      selected: options[:selected],
      collection: options[:collection]
    }.merge options[:options]
  end

  def value_from_params(model_class:, property:, type:)
    case type
    when :polymorphic_association, 'polymorphic_association'
      {
        id: params.dig(model_class.to_s.underscore, property.to_s),
        type: params.dig(model_class.to_s.underscore, "#{property}_type")
      }
    else
      params.dig(model_class.to_s.underscore, property.to_s)
    end
  end

  def default_params(property:, object:, form_object:, value:, options: {})
    {
      label: false,
      input_html: {
        name: "#{object}[#{property}]",
        id: "#{object}_#{property}",
        value: (form_object.send(property) || form_object.model.send(property) || value)
      },
      selected: (form_object.model.send(property) || value)
    }.merge options
  end

  def simple_params(**options)
    builded_options = { as: options[:type], label: false,
                        input_html: {
                          name: "#{options[:object]}[#{options[:property]}]",
                          id: "#{options[:object]}_#{options[:property]}",
                          value: build_simple_value(
                            *options.values_at(:form_object, :property, :value),
                            options.dig(:options, :input_html, :value)
                          )
                        } }
    merge_with_user_options builded_options, options
  end

  def build_simple_value(form_object, property, value, input_html_value)
    value_to_add = input_html_value || value
    value_to_add || form_object.send(property)
  end

  def merge_with_user_options(builded_options, options)
    if options[:options].present?
      options[:options].dig(:input_html)&.delete(:value)
      builded_options.merge!(options) || {}
    end
    builded_options
  end
end
