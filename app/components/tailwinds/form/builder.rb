# frozen_string_literal: true

module Tailwinds
  module Form
    # Provides Tailwind-styled forms
    # :reek:InstanceVariableAssumption
    class Builder < Tramway::Views::FormBuilder
      def text_field(attribute, **options, &)
        render(Tailwinds::Form::TextFieldComponent.new(**default_options(attribute, options)), &)
      end

      def password_field(attribute, **options, &)
        render(Tailwinds::Form::TextFieldComponent.new(**default_options(attribute, options)), &)
      end

      def file_field(attribute, **options, &)
        render(Tailwinds::Form::FileFieldComponent.new(**default_options(attribute, options)), &)
      end

      def select(attribute, collection, **options, &)
        render(Tailwinds::Form::SelectComponent.new(**default_options(attribute, options).merge(collection:)), &)
      end

      def submit(action, **options, &)
        render(Tailwinds::Form::SubmitButtonComponent.new(action, **options), &)
      end

      private

      def default_options(attribute, options)
        {
          template: @template,
          attribute:,
          object_name:,
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
