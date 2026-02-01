# frozen_string_literal: true

require 'active_model'

module Tramway
  module Forms
    # Provides form validations for Tramway forms
    module Validations
      def self.included(base)
        base.include ActiveModel::Validations
        base.extend ClassMethods
      end

      # A collection of methods that would be using in users forms
      module ClassMethods
        def __initialize_validations(_subclass); end
      end

      # rubocop:disable Naming/PredicateMethod
      def __apply_validations(_params)
        valid?
      end
      # rubocop:enable Naming/PredicateMethod
    end
  end
end
