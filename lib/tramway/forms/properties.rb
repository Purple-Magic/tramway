# frozen_string_literal: true

module Tramway
  module Forms
    # This is `properties`. The main feature of Tramway Form
    module Properties
      # A collection of methods that would be using in users forms
      module ClassMethods
        def property(attribute)
          @properties << attribute

          define_method(attribute) do
            if object.respond_to?(attribute)
              object.public_send(attribute)
            else
              raise NoMethodError, "#{self.class}##{attribute} is not defined"
            end
          end

          set_method = "#{attribute}="

          define_method(set_method) do |value|
            if object.respond_to?(set_method)
              object.public_send(set_method, value)
            else
              raise NoMethodError, "#{self.class}##{set_method} is not defined"
            end
          end
        end

        def properties(*attributes)
          attributes.any? ? __set_properties(attributes) : __properties
        end

        def __set_properties(attributes)
          attributes.each do |attribute|
            property(attribute)
          end
        end

        def __properties
          (__ancestor_properties + @properties).uniq
        end

        # :reek:ManualDispatch { enabled: false }
        def __ancestor_properties(klass = superclass)
          superklass = klass.superclass

          return [] unless superklass.respond_to?(:properties)

          klass.properties + __ancestor_properties(superklass)
        end

        # :reek:UtilityFunction { enabled: false }
        def __initialize_properties(subclass)
          subclass.instance_variable_set(:@properties, [])
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end

      def __apply_properties(params)
        self.class.properties.each do |attribute|
          public_send("#{attribute}=", params[attribute]) if params.key?(attribute)
        end
      end
    end
  end
end
