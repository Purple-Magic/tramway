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
    DEFAULT_BUTTON_CLASSES = %w[
      inline-flex items-center justify-center rounded-md font-medium ring-offset-background transition-colors
      focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2
      disabled:pointer-events-none disabled:opacity-50
    ].freeze

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

      {
        small: 'text-sm py-1 px-2 rounded',
        medium: 'text-sm py-2 px-4 h-10',
        large: 'text-xl px-5 py-3 h-12'
      }[normalized_size]
    end

    def default_button_classes
      DEFAULT_BUTTON_CLASSES
    end

    def classes
      (default_button_classes +
        size_classes.split +
        color_classes +
        (@tag == :a ? %w[px-1 h-fit w-fit] : [cursor_class]) +
        options[:class].to_s.split).compact.join(' ')
    end

    def color_classes
      theme_classes classic: color_classes_collection
    end

    def color_classes_collection
      return %w[bg-gray-800 text-gray-500 shadow-inner] if disabled?

      case normalized_type
      when :default, :life, :secondary
        ['hover:bg-zinc-200', 'bg-zinc-50', 'text-zinc-950']
      when :inverse
        ['hover:bg-zinc-800', 'bg-zinc-950', 'text-zinc-50', 'border', 'border-zinc-800']
      else
        ["hover:bg-#{resolved_color}-900 bg-#{resolved_color}-900/30 text-#{resolved_color}-400"]
      end
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

    def cursor_class
      if @tag != :a && !disabled?
        'cursor-pointer'
      else
        'cursor-not-allowed'
      end
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
