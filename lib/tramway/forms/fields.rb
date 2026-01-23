# frozen_string_literal: true

module Tramway
  module Forms
    # Provides field definitions for tramway_form_for
    module Fields
      # Class methods for defining fields
      module ClassMethods
        def fields(**attributes)
          attributes.any? ? __set_fields(attributes) : __fields
        end

        def __set_fields(attributes)
          attributes.each do |(attribute, field_data)|
            @fields.merge! attribute => field_data
          end
        end

        def __fields
          @fields.merge(__ancestor_fields)
        end

        def __ancestor_fields(klass = superclass)
          superklass = klass.superclass

          return {} unless superklass.respond_to?(:fields)

          klass.fields.merge(__ancestor_fields(superklass))
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
