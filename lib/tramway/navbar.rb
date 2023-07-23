# frozen_string_literal: true

require 'tramway/utils/render'
require 'tramway/utils/navbars/render'

module Tramway
  # Navbar object provides left and right elements
  class Navbar
    include Tramway::Utils::Render
    include Tramway::Utils::Navbars::Render

    attr_reader :items, :context

    def initialize(context)
      @context = context
      @items = { left: [], right: [] }
      @filling = nil

      entities = Tramway.config.entities

      return unless entities.any?

      preset_left entities
    end

    def left
      return unless block_given?

      filling_side(:left)
      yield self
      reset_filling
    end

    def right
      return unless block_given?

      filling_side(:right)
      yield self
      reset_filling
    end

    def item(text_or_url, url = nil, **options, &block)
      raise 'You cannot provide an argument and a code block at the same time' if provided_url_and_block?(url, &block)

      rendered_item = if url.present?
                        render_ignoring_block(text_or_url, url, options)
                      else
                        render_using_block(text_or_url, options, &block)
                      end

      @items[@filling] << rendered_item
    end

    private

    def preset_left(entities)
      filling_side :left

      entities.each do |entity|
        entity.to_s.pluralize

        item entity.human_name.plural, entity.routes.index
      end

      reset_filling
    end

    def provided_url_and_block?(url)
      url.present? && block_given?
    end

    def filling_side(side)
      @filling = side
    end

    def reset_filling
      @filling = nil
    end

    def render_ignoring_block(text_or_url, url, options)
      options.merge!(href: url)

      context.render(Tailwinds::Nav::ItemComponent.new(**options)) { text_or_url }
    end

    def render_using_block(text_or_url, options, &block)
      options.merge!(href: text_or_url)

      context.render(Tailwinds::Nav::ItemComponent.new(**options), &block)
    end
  end
end
