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
      raise 'You try to set empty Tramway entities' if collection.nil?

      @entities = collection.map do |entity|
        Tramway::Configs::Entity.new(name: entity)
      end
    end

    attr_reader :entities
  end
end
