# frozen_string_literal: true

require 'tramway/version'
require 'tramway/engine'
require 'tramway/base_decorator'
require 'tramway/config'
require 'view_component/compiler'
require 'view_component/engine'

# Core module for the whole gem
module Tramway
  module_function

  def configure(&)
    yield config
  end

  def config
    Tramway::Config.instance
  end
end
