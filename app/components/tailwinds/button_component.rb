# frozen_string_literal: true

module Tailwinds
  # Default Tramway button
  #
  class ButtonComponent < BaseComponent
    option :text, optional: true, default: -> {}
    option :path
    option :color, default: -> { :blue }
    option :type, default: -> { :default }
    option :size, default: -> { :middle }
    option :method, optional: true, default: -> { :get }
    option :options, optional: true, default: -> { {} }

    def size_classes
      case size
      when :small
        'text-sm py-1 px-1'
      when :middle
        'py-2 px-4'
      end
    end

    def classes
      (default_classes +
        light_mode_classes +
        dark_mode_classes +
        (method == :get ? %w[px-1 h-fit] : ['cursor-pointer'])).compact.join(' ')
    end

    def default_classes
      [
        'btn',
        'btn-primary',
        'font-bold',
        'rounded-sm',
        'flex',
        'flex-row',
        size_classes.to_s,
        options[:class].to_s
      ]
    end

    def light_mode_classes
      [
        "bg-#{color}-500",
        "hover:bg-#{color}-700",
        'text-white'
      ]
    end

    def dark_mode_classes
      [
        "dark:bg-#{color}-600",
        "dark:hover:bg-#{color}-800",
        'dark:text-gray-300'
      ]
    end
  end
end
