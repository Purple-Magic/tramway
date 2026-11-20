# frozen_string_literal: true

module Tramway
  # Tooltip options handling for Tramway button
  module ButtonComponentTooltip
    def tooltip_options
      {
        text: tooltip_value(:text),
        event: tooltip_value(:event)
      }
    end

    private

    def validate_tooltip!
      return if tooltip.blank?
      return if tooltip.is_a?(Hash) && tooltip_key?(:text) && tooltip_key?(:event)

      raise ArgumentError, 'Tooltip must be a hash with :text and :event keys.'
    end

    def tooltip_key?(key)
      tooltip.key?(key) || tooltip.key?(key.to_s)
    end

    def tooltip_value(key)
      tooltip[key] || tooltip[key.to_s]
    end
  end

  # Default Tramway button
  #
  class ButtonComponent < BaseComponent
    DEFAULT_BUTTON_CLASSES = %w[tramway-button].freeze

    option :text, optional: true, default: -> {}
    option :path, optional: true, default: -> { '#' }
    option :color, optional: true
    option :type, optional: true
    option :size, default: -> { :medium }
    option :method, optional: true, default: -> { :get }
    option :tag, optional: true, default: -> {}
    option :tooltip, optional: true, default: -> {}
    option :options, optional: true, default: -> { {} }
    option :form_options, optional: true, default: -> { {} }

    include Tramway::ColorsMethods
    include Tramway::ButtonComponentTooltip

    def before_render
      validate_tooltip!
      return if tag.present?

      @tag = if tag_button?
               :button
             elsif tag_a?
               :a
             else
               :form
             end
    end

    def size_classes
      unless normalized_size.in?(%i[small medium large])
        raise ArgumentError, "Invalid size: #{size}. Valid sizes are :small, :medium, :large."
      end

      { small: 'tramway-button--sm', medium: '', large: 'tramway-button--lg' }[normalized_size]
    end

    def default_button_classes
      DEFAULT_BUTTON_CLASSES
    end

    def classes
      (default_button_classes +
        size_classes.split +
        color_classes +
        options[:class].to_s.split).compact.join(' ')
    end

    def color_classes
      variant_classes('tramway-button')
    end

    def disabled?
      options[:disabled] || false
    end

    def render_options
      base_options = options.except(:class)
      return base_options unless stop_cell_propagation?

      base_options.merge(onclick: merged_onclick(base_options[:onclick]))
    end

    private

    def stop_cell_propagation?
      view_context.respond_to?(:tramway_inside_cell) && view_context.tramway_inside_cell
    end

    def merged_onclick(existing_onclick)
      return 'event.stopPropagation();' if existing_onclick.blank?

      "#{existing_onclick}; event.stopPropagation();"
    end

    def normalized_size
      size || :medium
    end

    def tag_button?
      options[:type] == :submit
    end

    def tag_a?
      return true unless path.is_a?(String)
      return false unless method.to_s.downcase == 'get'

      uri = URI.parse(path)

      uri.query.nil? || (uri.query && !uri.query.empty?) # rubocop:disable Rails/Present
    end
  end
end
