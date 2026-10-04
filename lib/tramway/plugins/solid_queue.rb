# frozen_string_literal: true

require 'tramway/plugins/solid_queue/config'
require 'tramway/plugins/solid_queue/routes'
require 'tramway/plugins/solid_queue/plugin'

Tramway::Plugins.register(Tramway::Plugins::SolidQueue::Plugin)
