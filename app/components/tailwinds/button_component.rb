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
        middle: 'py-2 px-4',
        large: 'text-lg px-5 py-3'
      }[size]
    end

    def classes
      (default_classes +
        color_classes +
        (render_a_tag? ? %w[px-1 h-fit] : [cursor_class])).compact.join(' ')
    end

    def default_classes
      [
        'btn', 'btn-primary', 'flex', 'flex-row', 'font-bold', 'rounded-sm', 'flex', 'flex-row', 'whitespace-nowrap',
        'items-center', 'gap-1', size_classes.to_s, options[:class].to_s
      ]
    end

    def color_classes
      if disabled?
        %w[bg-gray-400 text-gray-100]
      else
        [
          "bg-#{resolved_color}-600",
          "hover:bg-#{resolved_color}-800",
          'text-gray-300'
        ]
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

    private

    def cursor_class
      if !render_a_tag? && !disabled?
        'cursor-pointer'
      else
        'cursor-not-allowed'
      end
    end
  end
end
