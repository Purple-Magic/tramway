# frozen_string_literal: true

require 'anyway'
require 'singleton'
require 'tramway/configs/entity'

module Tramway
  # Basic configuration of Tramway
  #
  class Config < Anyway::Config
    include Singleton

    attr_config(
      pagination: { enabled: false },
      entities: [],
      application_controller: 'ActionController::Base',
      theme: :classic
    )

    def entities=(collection)
      super(collection.map do |entity|
        entity_options = entity.is_a?(Hash) ? entity : { name: entity }

        Tramway::Configs::Entity.new(**entity_options)
      end)
    end
  end
end
