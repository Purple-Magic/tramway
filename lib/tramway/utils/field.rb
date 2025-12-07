# frozen_string_literal: true

module Tramway
  module Utils
    # Provides dynamic field rendering
    module Field
      def tramway_field(field_type, attribute, **, &)
        if field_type.is_a?(Hash)
          name = field_name(field_type[:type])
          value = field_type[:value].call

          public_send(name, attribute, value:, **, &)
        else
          public_send(field_name(field_type), attribute, **, &)
        end
      end

      private

      def field_name(field_type)
        case field_type.to_sym
        when :text_area, :select, :multiselect
          field_type
        else
          "#{field_type}_field"
        end
      end
    end
  end
end
