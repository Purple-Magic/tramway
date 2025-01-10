# frozen_string_literal: true

module Tramway
  module Decorators
    # Provides method to determine decorators classes
    module ClassHelper
      module_function

      def decorator_class(object_or_array, decorator = nil)
        if object_or_array.blank? && decorator.nil?
          text = 'You should pass object or array that is not empty OR provide a decorator class as a second argument'

          raise ArgumentError, text
        end

        if decorator.present?
          decorator
        else
          begin
            class_name = decorator_class_name(object_or_array)
            class_name.constantize
          rescue NameError
            raise NameError, "You should define #{class_name} decorator class."
          end
        end
      end

      def decorator_class_name(object_or_array)
        klass = if Tramway::Decorators::CollectionDecorators.collection?(object_or_array)
                  object_or_array.first.class
                else
                  object_or_array.class
                end

        Tramway::Decorators::NameBuilder.default_decorator_class_name(klass)
      end
    end
  end
end
