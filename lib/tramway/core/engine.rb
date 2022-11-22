# frozen_string_literal: true

require 'tramway/core/generators/install_generator'
require 'tramway/core/application'
require 'simple_form'
require 'enumerize'

class Tramway::Core::Engine < ::Rails::Engine
  isolate_namespace Tramway::Core

  config.before_initialize do
    config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
  end
end
