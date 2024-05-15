# frozen_string_literal: true

module Tramway
  module Decorators
    module NameBuilder
      module_function

      def default_decorator_class_name(klass)
        "#{klass}Decorator"
      end
    end
  end
end
