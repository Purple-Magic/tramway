# frozen_string_literal: true

module Tramway
  # Default Tramway button
  #
  class ButtonComponent < BaseComponent
    option :text, optional: true, default: -> {}
    option :path, optional: true, default: -> { '#' }
    option :color, optional: true
    option :type, optional: true
    option :size, default: -> { :medium }
    option :method, optional: true, default: -> { :get }
    option :tag, optional: true, default: -> {}
    option :options, optional: true, default: -> { {} }
    option :form_options, optional: true, default: -> { {} }

    include Tramway::ColorsMethods

    def before_render
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
      unless size.in?(%i[small medium large])
        raise ArgumentError, "Invalid size: #{size}. Valid sizes are :small, :medium, :large."
      end

      return anchor_size_classes if @tag == :a

      {
        small: 'h-8 rounded-md px-3 text-xs md:px-4',
        medium: 'h-9 rounded-md px-4 py-2 md:px-6',
        large: 'h-10 rounded-md px-8 text-base md:px-10'
      }[size]
    end

    def classes
      (default_classes +
        color_classes +
        (@tag == :a ? ['w-fit', cursor_class] : [cursor_class])).compact.join(' ')
    end

    def default_classes
      base_classes = theme_classes(
        classic: %w[
          inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-colors
          focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-zinc-300 disabled:pointer-events-none
          disabled:opacity-50
        ]
      )

      base_classes + [size_classes.to_s, options[:class].to_s]
    end

    def color_classes
      if disabled?
        %w[pointer-events-none opacity-50]
      else
        shadcn_button_variant_classes.split
      end => classes_collection

      theme_classes classic: classes_collection
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
      disabled? ? 'cursor-not-allowed' : 'cursor-pointer'
    end

    def anchor_size_classes
      {
        small: 'h-8 rounded-md px-4 text-xs md:px-5',
        medium: 'h-9 rounded-md px-5 py-2 md:px-7',
        large: 'h-10 rounded-md px-9 text-base md:px-11'
      }[size]
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
