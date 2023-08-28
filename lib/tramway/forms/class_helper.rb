# frozen_string_literal: true

module Tramway
  module Forms
    # Provides method to determine decorators classes
    module ClassHelper
      module_function

      def form_class(object, form, namespace)
        if form.present?
          form
        else
          if namespace.present?
            "#{namespace.to_s.camelize}::#{object.class}Form".constantize
          else
            "#{object.class}Form".constantize
          end
        end
      end
    end
  end
end
