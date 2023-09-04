# frozen_string_literal: true

require 'tramway/forms/class_helper'

module Tramway
  module Helpers
    # Provides methods into Rails ActionController
    #
    module FormHelper
      def tramway_form(object, form: nil, namespace: nil)
        Tramway::Forms::ClassHelper.form_class(object, form, namespace).new object
      end
    end
  end
end
