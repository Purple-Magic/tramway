require 'tramway/helpers/component_helper'

module Tramway
  module ApplicationHelper
    include Tramway::Decorators::ClassHelper
    include Tramway::Helpers::ComponentHelper

    def page_title
      @model_class.model_name.human.pluralize
    end
  end
end
