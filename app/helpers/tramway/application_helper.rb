# frozen_string_literal: true

require 'tramway/helpers/component_helper'
require 'tramway/helpers/views_helper'
require 'kaminari/helpers/tag'

module Tramway
  # Main helper module for Tramway entities pages
  module ApplicationHelper
    include Tramway::Decorators::ClassHelper
    include Tramway::Helpers::ComponentHelper
    include Tramway::Helpers::ViewsHelper

    def page_title
      @model_class.model_name.human.pluralize # rubocop:disable Rails/HelperInstanceVariable
    end
  end
end
