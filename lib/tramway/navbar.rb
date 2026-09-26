# frozen_string_literal: true

module Tramway
  # Navbar object provides left and right elements
  class Navbar
    attr_reader :items, :context

    def initialize(context, with_entities:)
      @context = context
      @items = { left: [], right: [] }
      @filling = nil

      return unless with_entities

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

    def item(text_or_url, url = nil, icon: nil, **, &)
      raise 'You cannot provide an argument and a code block at the same time' if provided_url_and_block?(url, &)

      if url.present?
        render_ignoring_block(text_or_url, url, icon:, **)
      else
        render_using_block(text_or_url, icon:, **, &)
      end => rendered_item

      @items[@filling] << rendered_item
    end

    private

    def preset_left(entities)
      filling_side :left

      entities.each do |entity|
        next if entity.routes.index.blank?

        item entity.human_name.plural, Tramway::Engine.routes.url_helpers.public_send(entity.routes.index)
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

    def render_ignoring_block(text_or_url, url, method: nil, icon: nil, **options)
      options.merge!(href: url, icon:)
      apply_icon_accessibility_attributes(options, label: text_or_url, icon:)

      if method.present? && method.to_sym != :get
        context.render(Tramway::Nav::Item::ButtonComponent.new(method:, **options)) { text_or_url }
      else
        context.render(Tramway::Nav::Item::LinkComponent.new(method:, **options)) { text_or_url }
      end
    end

    def render_using_block(text_or_url, method: nil, icon: nil, **options, &)
      options.merge!(href: text_or_url, icon:)

      if method.present? && method.to_sym != :get
        context.render(Tramway::Nav::Item::ButtonComponent.new(method:, **options), &)
      else
        context.render(Tramway::Nav::Item::LinkComponent.new(method:, **options), &)
      end
    end

    def apply_icon_accessibility_attributes(options, label:, icon:)
      return if icon.blank?

      options[:title] = label if options[:title].blank?
      options[:'aria-label'] = label if options[:'aria-label'].blank?
    end
  end
end
