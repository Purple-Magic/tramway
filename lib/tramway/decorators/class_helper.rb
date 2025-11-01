# frozen_string_literal: true

module Tramway
  module Decorators
    # Provides method to determine decorators classes
    module ClassHelper
      module_function

      def decorator_class(object_or_array, decorator = nil, namespace = nil)
        raise_error_if_object_empty object_or_array, decorator

        return decorator if decorator.present?

        begin
          class_name = decorator_class_name(object_or_array, namespace)
          class_name.constantize
        rescue NameError
          raise NameError, "You should define #{class_name_for_error(object_or_array, namespace)} decorator class."
        end
      end

      def decorator_class_name(object_or_array_or_class, namespace)
        if Tramway::Decorators::CollectionDecorators.collection?(object_or_array_or_class)
          object_or_array_or_class.first.class
        elsif object_or_array_or_class.is_a?(Class)
          object_or_array_or_class
        else
          object_or_array_or_class.class
        end => klass

        base_class_name = Tramway::Decorators::NameBuilder.default_decorator_class_name(klass)

        build_klass_name(base_class_name, namespace)
      end

      def raise_error_if_object_empty(object_or_array, decorator)
        return unless object_or_array.blank? && decorator.nil?

        text = 'You should pass object or array that is not empty OR provide a decorator class as a second argument'

        raise ArgumentError, text
      end

      def build_klass_name(base_class_name, namespace)
        klass_name = namespace.present? ? "#{namespace.to_s.camelize}::#{base_class_name}" : base_class_name

        unless klass_name.safe_constantize
          raise NameError, "You should define #{klass_name} decorator class in app/decorators/ folder."
        end

        klass_name
      end

      def class_name_for_error(object_or_array, namespace)
        object = object_or_array.respond_to?(:first) ? object_or_array.first : object_or_array

        base_class_name = "#{object.class.name}Decorator"

        namespace.present? ? "#{namespace}::#{base_class_name}" : base_class_name
      end
    end
  end
end
