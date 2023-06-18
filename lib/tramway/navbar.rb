# frozen_string_literal: true

module Tramway
  # Navbar class for Tramway navbars
  #
  class Navbar
    attr_reader :items

    def initialize(context)
      @items = {}
      @context = context
    end

    def left
      return unless block_given?

      @items[:left] = []

      @filling = :left

      yield self
    end

    def right
      return unless block_given?

      @items[:right] = []

      @filling = :right

      yield self
    end

    def item(text_or_url, url = nil, **options, &block)
      raise 'You can not provide argument and code block in the same time' if url.present? && block_given?

      rendered_item = if url.present?
                        options.merge! href: url
                        @context.render(Tailwinds::Nav::ItemComponent.new(**options)) { text_or_url }
                      else
                        options.merge! href: text_or_url
                        @context.render(Tailwinds::Nav::ItemComponent.new(**options), &block)
                      end

      @items[@filling] << rendered_item
    end
  end
end
