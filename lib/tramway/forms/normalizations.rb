# frozen_string_literal: true

module Tramway
  module Forms
    # This is the same `normalizes` feature like in Rails
    # https://api.rubyonrails.org/v7.1/classes/ActiveRecord/Normalization/ClassMethods.html#method-i-normalizes
    module Normalizations
      def normalizes(attribute, with:)
        @normalizations.merge!(attribute => with)
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
  end
end
