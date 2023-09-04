# frozen_string_literal: true

module Tramway
  module Forms
    # Provides method to determine decorators classes
    module ClassHelper
      module_function

      def form_class(object, form, namespace)
        object_class = object.class

        if form.present?
          form
        elsif namespace.present?
          "#{namespace.to_s.camelize}::#{object_class}Form".constantize
        else
          "#{object_class}Form".constantize
        end
      end
    end
  end
end
