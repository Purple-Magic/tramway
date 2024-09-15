# frozen_string_literal: true

module Tramway
  module Decorators
    # Provides method to determine decorators classes
    module ClassHelper
      module_function

      def decorator_class(object_or_array, decorator = nil)
        if decorator.present?
          decorator
        else
          begin
            decorator_class_name(object_or_array).constantize
          rescue NameError
            raise NameError, "You should define #{decorator_class_name(object_or_array)} decorator class."
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
