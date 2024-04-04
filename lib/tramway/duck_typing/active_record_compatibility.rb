# frozen_string_literal: true

module Tramway
  module DuckTyping
    # This module is used to make duck object compatible with ActiveRecord objects
    module ActiveRecordCompatibility
      # Contains behave_as_ar method
      module ClassMethods
        def behave_as_ar
          %i[update update! destroy].each do |method_name|
            delegate method_name, to: :object
          end
        end
      end

      %i[id model_name to_key errors to_param attributes].each do |method_name|
        delegate method_name, to: :object
      end

      def self.included(base)
        base.extend ClassMethods
      end
    end
  end
end
