# frozen_string_literal: true

require 'tramway/decorators/class_helper'

module Tramway
  module Helpers
    # Provides methods into Rails ActionController
    #
    module DecorateHelper
      def tramway_decorate(object_or_array, decorator: nil)
        Tramway::Decorators::ClassHelper.decorator_class(object_or_array, decorator).decorate object_or_array, self
      end
    end
  end
end
