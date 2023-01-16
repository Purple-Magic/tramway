# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'tramway'

module Dummy
  class Application < Rails::Application
    config.i18n.default_locale = :en
    config.load_defaults 5.1
  end
end
