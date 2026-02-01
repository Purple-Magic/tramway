# frozen_string_literal: true

module Tramway
  module Forms
    # Provides form validations for Tramway forms
    module Validations
      # A collection of methods that would be using in users forms
      module ClassMethods
        # :reek:BooleanParameter { enabled: false }
        def validates(*attributes, with:, message: 'is invalid', allow_nil: false)
          attributes.each do |attribute|
            @validations[attribute] ||= []
            @validations[attribute] << { proc: with, message:, allow_nil: }
          end
        end

        def validations
          __ancestor_validations.merge(@validations) do |_attribute, ancestor_validations, own_validations|
            ancestor_validations + own_validations
          end
        end

        # :reek:ManualDispatch { enabled: false }
        def __ancestor_validations(klass = superclass)
          superklass = klass.superclass

          return {} unless superklass.respond_to?(:validations)

          klass.validations.merge(__ancestor_validations(superklass)) do |_attribute, ancestor_validations, parent_validations|
            ancestor_validations + parent_validations
          end
        end

        # :reek:UtilityFunction { enabled: false }
        def __initialize_validations(subclass)
          subclass.instance_variable_set(:@validations, {})
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end

      # :reek:NilCheck { enabled: false }
      def __apply_validations(params)
        validations_map = self.class.validations
        return true if validations_map.empty?

        object.errors.clear

        validations_map.each do |attribute, validations|
          value = if params.key?(attribute)
                    params[attribute]
                  elsif object.respond_to?(attribute)
                    object.public_send(attribute)
                  end

          validations.each do |validation|
            next if value.nil? && validation[:allow_nil]

            next if instance_exec(value, &validation[:proc])

            object.errors.add(attribute, validation[:message])
          end
        end

        object.errors.empty?
      end
    end
  end
end
