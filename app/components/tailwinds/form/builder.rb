# frozen_string_literal: true

module Tailwinds
  module Form
    # Provides Tailwind-styled forms
    # :reek:InstanceVariableAssumption
    class Builder < Tramway::Views::FormBuilder
      def text_field(attribute, **options, &)
        render(Tailwinds::Form::TextFieldComponent.new(
                 input: input(:text_field),
                 value: get_value(attribute, options),
                 **default_options(attribute, options)
               ), &)
      end

      def password_field(attribute, **options, &)
        render(Tailwinds::Form::TextFieldComponent.new(
                 input: input(:password_field),
                 **default_options(attribute, options)
               ), &)
      end

      def file_field(attribute, **options, &)
        input = super(attribute, **options.merge(class: :hidden))

        render(Tailwinds::Form::FileFieldComponent.new(input:, **default_options(attribute, options)), &)
      end

      def select(attribute, collection, **options, &)
        render(Tailwinds::Form::SelectComponent.new(
                 input: input(:select),
                 value: options[:selected] || object.public_send(attribute),
                 collection: explicitly_add_blank_option(collection, options),
                 **default_options(attribute, options)
               ), &)
      end

      def multiselect(attribute, collection, **options, &)
        render(Tailwinds::Form::MultiselectComponent.new(
                 input: input(:text_field),
                 value: options[:value] || options[:selected] || object.public_send(attribute),
                 collection:,
                 **default_options(attribute, options)
               ), &)
      end

      def submit(action, **options, &)
        render(Tailwinds::Form::SubmitButtonComponent.new(action, **options), &)
      end

      private

      def input(method_name)
        unbound_method = self.class.superclass.instance_method(method_name)
        unbound_method.bind(self)
      end

      def get_value(attribute, options)
        options[:value] || object.public_send(attribute)
      end

      def default_options(attribute, options)
        {
          attribute:,
          label: label_build(attribute, options),
          for: for_id(attribute),
          options:
        }
      end

      # :reek:UtilityFunction
      # :reek:NilCheck
      def label_build(attribute, options)
        label_option = options[:label]

        label_option.nil? ? attribute.to_s.humanize : label_option
      end

      def for_id(attribute)
        "#{object_name}_#{attribute}"
      end

      # REMOVE IT. WE MUST UNDERSTAND WHY INCLUDE_BLANK DOES NOT WORK
      # :reek:UtilityFunction
      def explicitly_add_blank_option(collection, options)
        if options[:include_blank]
          collection = collection.to_a if collection.is_a? Hash

          collection.unshift([nil, ''])
        else
          collection
        end
      end
    end
  end
end
