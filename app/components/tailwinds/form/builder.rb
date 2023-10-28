# frozen_string_literal: true

module Tailwinds
  module Form
    # Provides Tailwind-styled forms
    class Builder < Tramway::Views::FormBuilder
      def text_field(attribute, **options, &)
        input = super(attribute, **options.merge(class: text_input_class))
        render(Tailwinds::Form::TextFieldComponent.new(input, attribute, object_name:, **options), &)
      end

      def password_field(attribute, **options, &)
        input = super(attribute, **options.merge(class: text_input_class))
        render(Tailwinds::Form::TextFieldComponent.new(input, attribute, object_name:, **options), &)
      end

      def file_field(attribute, **options, &)
        input = super(attribute, **options.merge(class: :hidden))

        render(Tailwinds::Form::FileFieldComponent.new(input, attribute, object_name:, **options), &)
      end

      def submit(action, **options, &)
        render(Tailwinds::Form::SubmitButtonComponent.new(action, **options), &)
      end

      private

      def text_input_class
        'w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-red-500'
      end
    end
  end
end
