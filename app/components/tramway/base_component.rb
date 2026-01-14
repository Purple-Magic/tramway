# frozen_string_literal: true

require 'tramway/helpers/component_helper'
require 'tramway/helpers/decorate_helper'
require 'tramway/helpers/views_helper'

module Tramway
  # You can use this class as a base for all your components
  class BaseComponent < ViewComponent::Base
    extend Dry::Initializer[undefined: false]
    include Tramway::Helpers::ComponentHelper
    include Tramway::Helpers::DecorateHelper
    include Tramway::Helpers::ViewsHelper

    private

    def tramway_theme
      Tramway.config.theme.to_sym
    rescue NoMethodError
      :classic
    end

    def theme_classes(mapping = {}, fallback: :classic, **keyword_mapping)
      resolved_mapping = mapping.merge(keyword_mapping)
      resolved_mapping.fetch(tramway_theme) { resolved_mapping.fetch(fallback) }
    end
  end
end
