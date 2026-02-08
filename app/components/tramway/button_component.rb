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

      {
        small: 'text-sm py-1 px-2 rounded',
        medium: 'py-2 px-4 h-10',
        large: 'text-xl px-5 py-3 h-12'
      }[size]
    end

    def classes
      (default_classes +
        color_classes +
        (@tag == :a ? %w[px-1 h-fit w-fit] : [cursor_class])).compact.join(' ')
    end

    def default_classes
      base_classes = theme_classes(
        classic: %w[btn btn-primary flex flex-row font-semibold rounded-xl whitespace-nowrap items-center gap-1
                    shadow-md]
      )

      base_classes + [size_classes.to_s, options[:class].to_s]
    end

    def color_classes
      if disabled?
        %w[bg-gray-800 text-gray-500 shadow-inner]
      else
        [
          "bg-#{resolved_color}-700", "hover:bg-#{resolved_color}-800", 'text-white'
        ]
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
      if @tag != :a && !disabled?
        'cursor-pointer'
      else
        'cursor-not-allowed'
      end
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
