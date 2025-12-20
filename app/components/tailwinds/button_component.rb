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
        light_mode_classes +
        dark_mode_classes +
        (link ? %w[px-1 h-fit] : ['cursor-pointer'])).compact.join(' ')
    end

    def default_classes
      [
        'btn', 'btn-primary', 'flex', 'flex-row', 'font-bold', 'rounded-sm', 'flex', 'flex-row', 'whitespace-nowrap',
        'items-center', 'space-x-1', size_classes.to_s, options[:class].to_s
      ]
    end

    def light_mode_classes
      [
        "bg-#{resolved_color}-500",
        "hover:bg-#{resolved_color}-700",
        'text-white'
      ]
    end

    def dark_mode_classes
      [
        "dark:bg-#{resolved_color}-600",
        "dark:hover:bg-#{resolved_color}-800",
        'dark:text-gray-300'
      ]
    end
  end
end
