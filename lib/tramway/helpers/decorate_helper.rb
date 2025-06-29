# frozen_string_literal: true

require 'tramway/decorators/class_helper'

module Tramway
  module Helpers
    # Provides methods into Rails ActionController
    #
    module DecorateHelper
      # :reek:NilCheck { enabled: false } because checking for nil is not a type-checking issue but business logic
      def tramway_decorate(object_or_array, decorator: nil, namespace: nil)
        return [] if Tramway::Decorators::CollectionDecorators.collection?(object_or_array) && object_or_array.empty?

        return if object_or_array.nil?

        Tramway::Decorators::ClassHelper.decorator_class(object_or_array, decorator, namespace).decorate object_or_array
      end
    end
  end
end
