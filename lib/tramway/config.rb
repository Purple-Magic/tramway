# frozen_string_literal: true

require 'singleton'
require 'tramway/configs/entity'

module Tramway
  # Basic configuration of Tramway
  #
  class Config
    include Singleton

    def initialize
      @entities = []
    end

    def entities=(collection)
      @entities = collection.map do |entity|
        entity_options = entity.is_a?(Hash) ? entity : { name: entity }

        Tramway::Configs::Entity.new(**entity_options)
      end
    end

    attr_reader :entities
  end
end
