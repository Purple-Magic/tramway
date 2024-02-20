# frozen_string_literal: true

module Tramway
  module Forms
    # This is the same `normalizes` feature like in Rails
    # https://api.rubyonrails.org/v7.1/classes/ActiveRecord/Normalization/ClassMethods.html#method-i-normalizes
    module Normalizations
      # A collection of methods that would be using in users forms
      module ClassMethods
        # :reek:BooleanParameter { enabled: false }
        def normalizes(*attributes, with:, apply_to_nil: false)
          attributes.each do |attribute|
            @normalizations.merge!(attribute => { proc: with, apply_to_nil: })
          end
        end

        def normalizations
          __ancestor_normalizations.merge(@normalizations)
        end

        # :reek:ManualDispatch { enabled: false }
        def __ancestor_normalizations(klass = superclass)
          superklass = klass.superclass

          return {} unless superklass.respond_to?(:normalizations)

          klass.normalizations.merge!(__ancestor_normalizations(superklass))
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end

      def __apply_normalizations(params)
        self.class.normalizations.reduce(params) do |hash, (attribute, normalization)|
          if hash.key?(attribute) || normalization[:apply_to_nil]
            hash.merge(attribute => instance_exec(hash[attribute], &normalization[:proc]))
          else
            hash
          end
        end
      end
    end
  end
end
