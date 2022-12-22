# frozen_string_literal: true

module Tramway
  module ExtendableFormsHelpers
    module IgnoredPropertiesHelper
      def define_ignored_properties_method
        define_method :jsonb_ignored_properties do |properties|
          properties.map do |property|
            property[0].to_s if property[1][:object].field_type == 'file'
          end.compact
        end
      end
    end
  end
end
