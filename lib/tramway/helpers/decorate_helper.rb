# frozen_string_literal: true

module Tramway
  module Helpers
    # Provides methods into Rails ActionController
    #
    module DecorateHelper
      def tramway_decorate(object_or_array, decorator: nil)
        decorator_class(object_or_array, decorator).decorate object_or_array, self
      end

      private

      def decorator_class(object_or_array, decorator)
        if decorator.present?
          decorator
        else
          klass = if object_or_array.is_a? ActiveRecord::Relation
                    object_or_array.first.class
                  else
                    object_or_array.class
                  end

          "#{klass}Decorator".constantize
        end
      end
    end
  end
end
