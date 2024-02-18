# frozen_string_literal: true

module Tramway
  module Forms
    # This is `properties`. The main feature of Tramway Form
    module Properties
      def property(attribute)
        @properties << attribute

        delegate attribute, to: :object
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
    end
  end
end
