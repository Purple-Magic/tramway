# frozen_string_literal: true

require 'types'
require 'tramway/version'
require 'tramway/engine'
require 'tramway/base_decorator'
require 'tramway/base_form'
require 'tramway/config'
require 'tramway/duck_typing'
require 'tramway/views/form_builder'
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
