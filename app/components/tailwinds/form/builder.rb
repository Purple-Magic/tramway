# frozen_string_literal: true

module Tailwinds
  module Form
    # Provides Tailwind-styled forms
    # :reek:InstanceVariableAssumption
    class Builder < Tramway::Views::FormBuilder
      def text_field(attribute, **options, &)
        render(Tailwinds::Form::TextFieldComponent.new(
                 template: @template,
                 attribute:,
                 object_name:,
                 label: label(options, attribute),
                 for: for_id(attribute),
                 options:
               ), &)
      end

      def password_field(attribute, **options, &)
        render(Tailwinds::Form::TextFieldComponent.new(
                 template: @template,
                 attribute:,
                 object_name:,
                 label: label(options, attribute),
                 for: for_id(attribute),
                 options:
               ), &)
      end

      def file_field(attribute, **options, &)
        render(Tailwinds::Form::FileFieldComponent.new(
                 template: @template,
                 attribute:,
                 object_name:,
                 label: label(options, attribute),
                 for: for_id(attribute),
                 options:
               ), &)
      end

      def select(attribute, collection, **options, &)
        render(Tailwinds::Form::SelectComponent.new(
                 template: @template,
                 attribute:,
                 collection:,
                 object_name:,
                 label: label(options, attribute),
                 for: for_id(attribute),
                 options:
               ), &)
      end

      def submit(action, **options, &)
        render(Tailwinds::Form::SubmitButtonComponent.new(action, **options), &)
      end

      private

      # :reek:UtilityFunction
      def label(options, attribute)
        options[:label] || attribute.to_s.humanize
      end

      def for_id(attribute)
        "#{object_name}_#{attribute}"
      end
    end
  end
end
