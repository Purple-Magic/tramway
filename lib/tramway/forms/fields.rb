# frozen_string_literal: true

module Tramway
  module Forms
    # Provides field definitions for tramway_form_for
    module Fields
      # Class methods for defining fields
      module ClassMethods
        def fields(**attributes)
          @fields.merge! attributes
        end

        def __initialize_fields(subclass)
          subclass.instance_variable_set(:@fields, {})
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end
    end
  end
end
