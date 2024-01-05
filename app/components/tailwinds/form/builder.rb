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
                 collection:,
                 **default_options(attribute, options)
               ), &)
      end

      def submit(action, **options, &)
        render(Tailwinds::Form::SubmitButtonComponent.new(action, **options), &)
      end

      private

      def input(method_name)
        unbound_method = Tramway::Views::FormBuilder.instance_method(method_name)
        unbound_method.bind(self)
      end

      def get_value(attribute, options)
        options[:value] || object.public_send(attribute)
      end

      def default_options(attribute, options)
        {
          attribute:,
          label: label(attribute, options),
          for: for_id(attribute),
          options:
        }
      end

      # :reek:UtilityFunction
      def label(attribute, options)
        options[:label] || attribute.to_s.humanize
      end

      def for_id(attribute)
        "#{object_name}_#{attribute}"
      end
    end
  end
end
