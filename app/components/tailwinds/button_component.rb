# frozen_string_literal: true

module Tailwinds
  # Default Tramway button
  #
  class ButtonComponent < BaseComponent
    option :text, optional: true, default: -> {}
    option :path, optional: true, default: -> { '#' }
    option :color, optional: true
    option :type, optional: true
    option :size, default: -> { :middle }
    option :method, optional: true, default: -> { :get }
    option :link, optional: true, default: -> { false }
    option :options, optional: true, default: -> { {} }
    option :form_options, optional: true, default: -> { {} }

    def size_classes
      {
        small: 'text-sm py-1 px-2 rounded',
        middle: 'py-2 px-4 h-10',
        large: 'text-lg px-5 py-3'
      }[size]
    end

    def classes
      (default_classes +
        color_classes +
        (render_a_tag? ? %w[px-1 h-fit w-fit] : [cursor_class])).compact.join(' ')
    end

    def default_classes
      base_classes = theme_classes(
        classic: %w[btn btn-primary flex flex-row font-bold rounded-sm whitespace-nowrap items-center gap-1],
        neomorphism: %w[btn btn-primary flex flex-row font-semibold rounded-xl whitespace-nowrap items-center gap-1
                        shadow-md]
      )

      base_classes + [size_classes.to_s, options[:class].to_s]
    end

    def color_classes
      if disabled?
        theme_classes(
          classic: %w[bg-gray-400 text-gray-100],
          neomorphism: %w[bg-gray-200 text-gray-400 shadow-inner dark:bg-gray-800 dark:text-gray-500]
        )
      else
        theme_classes(
          classic: [
            "bg-#{resolved_color}-600",
            "hover:bg-#{resolved_color}-800",
            'text-gray-300'
          ],
          neomorphism: [
            "bg-#{resolved_color}-200",
            "hover:bg-#{resolved_color}-300",
            "text-#{resolved_color}-800",
            "dark:bg-#{resolved_color}-700",
            "dark:hover:bg-#{resolved_color}-600",
            "dark:text-#{resolved_color}-100"
          ]
        )
      end
    end

    def disabled?
      options[:disabled] || false
    end

    def render_a_tag?
      return true if link

      uri = URI.parse(path)

      return true if method.to_s.downcase == 'get' && uri.query && !uri.query.empty?

      false
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
      if !render_a_tag? && !disabled?
        'cursor-pointer'
      else
        'cursor-not-allowed'
      end
    end
  end
end
