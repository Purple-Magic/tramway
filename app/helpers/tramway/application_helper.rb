# frozen_string_literal: true

require 'tramway/helpers/component_helper'

module Tramway
  # Main helper module for Tramway entities pages
  module ApplicationHelper
    include Tramway::Decorators::ClassHelper
    include Tramway::Helpers::ComponentHelper

    def page_title
      @model_class.model_name.human.pluralize
    end
  end
end
