# frozen_string_literal: true

module Tailwinds
  module Form
    # Provides Tailwind-styled forms
    class Builder < Tramway::Views::FormBuilder
      def text_field(attribute, **options, &)
        input = super(attribute, **options.merge(class: text_input_class))
        render(Tailwinds::Form::TextFieldComponent.new(input, attribute, object_name:, **options), &)
      end

      alias password_field text_field

      def file_field(attribute, **options, &)
        input = super(
          attribute,
          **options.merge(
            class: :hidden,
            onchange: "document.getElementById('#{attribute}_label').textContent = this.files[0].name"
          )
        )

        render(Tailwinds::Form::FileFieldComponent.new(input, attribute, object_name:, **options), &)
      end

      private

      def text_input_class
        'w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-red-500'
      end
    end
  end
end
