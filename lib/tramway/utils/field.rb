# frozen_string_literal: true

module Tramway
  module Utils
    # Provides dynamic field rendering
    module Field
      def tramway_field(field_data, attribute, **options, &)
        input_type = field_type(field_data)
        input_name = field_name input_type
        input_options = field_options(field_data).merge(options)

        case input_type.to_sym
        when :select, :multiselect
          collection = input_options.delete(:collection)

          public_send(input_name, attribute, collection, **input_options, &)
        else
          public_send(input_name, attribute, **input_options, &)
        end
      end

      private

      def field_name(field_data)
        case field_data.to_sym
        when :text_area, :select, :multiselect, :check_box
          field_data
        when :checkbox
          :check_box
        else
          "#{field_data}_field"
        end
      end

      def field_type(field_data)
        if field_data.is_a?(Hash)
          field_data[:type]
        else
          field_data
        end
      end

      def field_options(field_data)
        if field_data.is_a?(Hash)
          value = field_data[:value]&.call

          field_data.merge(value:).except(:type)
        else
          {}
        end
      end
    end
  end
end
