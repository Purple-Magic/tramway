# frozen_string_literal: true

require 'tramway/helpers/component_helper'

module Tramway
  module Component
    # You can use this class as a base for all your components
    class Base < ViewComponent::Base
      extend Dry::Initializer[undefined: false]
      include Tramway::Helpers::ComponentHelper
    end
  end
end
