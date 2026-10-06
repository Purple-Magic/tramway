# frozen_string_literal: true

require 'anyway'
require 'singleton'
require 'tramway/configs/entity'
require 'tramway/configs/plugins'

module Tramway
  # Basic configuration of Tramway
  #
  class Config < Anyway::Config
    include Singleton

    attr_config(
      entities: [],
      application_controller: 'ActionController::Base',
      theme: :classic,
      plugins: []
    )

    def entities=(collection)
      super(collection.map do |entity|
        entity_options = entity.is_a?(Hash) ? entity : { name: entity }

        Tramway::Configs::Entity.new(**entity_options)
      end)
    end

    def plugins=(names)
      super(Tramway::Configs::Plugins.new(names))
    end
  end
end
