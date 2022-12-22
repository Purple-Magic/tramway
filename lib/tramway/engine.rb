# frozen_string_literal: true

require 'tramway/generators/install_generator'
require 'tramway/application'
require 'simple_form'
require 'enumerize'

module Tramway
  class Engine < ::Rails::Engine
    isolate_namespace Tramway

    config.before_initialize do
      config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end
  end
end
