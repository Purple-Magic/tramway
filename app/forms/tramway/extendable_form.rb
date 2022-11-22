# frozen_string_literal: true

class Tramway::ExtendableForm
  class << self
    include Tramway::ExtendableFormsHelpers::ClassBuilder

    def new(name, simple_properties: {}, **more_properties)
      if Object.const_defined? name
        name.constantize
      else
        build_form_class name, simple_properties, more_properties
      end
    end
  end
end
