# frozen_string_literal: true

require 'tramway/helpers/component_helper'

module Tramway
  # You can use this class as a base for all your components
  class BaseComponent < ViewComponent::Base
    extend Dry::Initializer[undefined: false]
    include Tramway::Helpers::ComponentHelper
    include Tramway::Helpers::DecorateHelper
    include Tramway::Helpers::ViewsHelper
  end
end
