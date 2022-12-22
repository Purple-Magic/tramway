# frozen_string_literal: true

module Tramway
  module ExtendableFormsHelpers
    module Submit
      module ObjectHelpers
        def extended(simple_properties, more_properties, params)
          params.except(*simple_properties.keys).except(*jsonb_ignored_properties(more_properties)).permit!.to_h
        end

        def every_attribute_set(params)
          params.each do |key, value|
            method_name = "#{key}="
            send(method_name, value) if respond_to?(method_name)
          end
        end

        def save_in_submit(_params)
          result = save
          result.tap do
            collecting_associations_errors unless result
          end
        end
      end
    end
  end
end
